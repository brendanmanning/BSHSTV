var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);

// Sockets
var sockets = [];

// Admin sockets
// .. the sockets of users who logged in the admin ui
var admin_sockets = [];

// Polling
var isPolling = false;
var poll = null;
var responses = [];

// This setting can make the server very slow
var shouldShowStatusBarsOnAdminGUI = false;

// Status
var isLive = false;

// Password
var pwd = "deannoestaaqui";

// Debugging
var debug = shouldBeVerbose();

// Announcements
var announcements = [];

// On this day
var days = [];

// Server type
var isMainServer = shouldBeMainServer();

// File reading
const videofile = __dirname + "/show/videos.txt";
const announcementsfile = __dirname + "/show/announcements.txt";
const readline = require('readline');
const fs = require('fs');
const rl = readline.createInterface({terminal: false, input: fs.createReadStream(videofile)});

fs.access(videofile, fs.F_OK, function(err) {
	if(err)
	{
		echo("Fatal Error: videos.txt could not be read.")
		echo("Create it at " + videofile);
		process.exit(-1);
	}
});

app.use(express.static(__dirname + '/public'));

app.get('/', function(req, res){
	if(isMainServer)
	{
  		res.sendFile(__dirname + "/index.html");
	} else {
		res.sendFile(__dirname + "/remote.html");
	}
});

app.get("/days", function(req, res){
	res.sendFile(__dirname + "/show/OnThisDay.txt")
});

app.get("/text.file", function(req, res) {
	res.sendFile(__dirname + "test.file");
});

http.listen(443, function(){
  console.log('listening on *:3000');
  echo('Restoring announcements from file');
  loadFromFile(announcementsfile,announcements);
  echo('Load into memory finished');
});

io.on('connection', function(socket){
  echo('a user connected');
  sockets.push(socket);
  
  // Send them the videos
  sendVideos(socket);
  updateConsoleUI();

  socket.emit('hello');

  if(isPolling) { poll.push(socket) }
  if(isLive) { socket.emit('live') } else { socket.emit('offair'); }

  pushAnnouncements(socket);

  socket.on('disconnect', function(){
    echo('user disconnected');
    updateConsoleUI();

    var indexOfDisconnectedSocket = indexOfSocket(socket);
    if(indexOfDisconnectedSocket != null)
    {
    	sockets.splice(indexOfDisconnectedSocket, 1);

    	// Search for the socket in the admin socket array
    	if(admin_sockets.indexOf(socket) != -1)
    	{
    		admin_sockets.splice(admin_sockets.indexOf(socket),1);
    	}
    } else {
    	echo("An error occured while removing a disconnected user");
    }
  });

	// Connections from the server manager
	socket.on('newpoll', function(choices, correct, token, prompt)
	{
		var shouldHide = false;
		if(correct == "f")
		{
			shouldHide = true;
		}
		if(!authRequest(token))
		{
			socket.emit('notauthed');
		} else {
			if(isPolling)
			{
				socket.emit('alreadypolling');
			} else {
				if(choices.length != 4) 
				{
					socket.emit("error", "You didn't supply four choices");
				} else {
					var ok = true;
					for(var i = 0; i < choices.length; i++)
					{
						if(choices[i] == "")
						{
							ok = false;
						}
					}
					if(correct == "") { ok = false; }
					if(prompt == "") { ok = false; }
					if(ok)
					{
						poll = new Poll(choices, correct, prompt);
						poll.pushAll();
						isPolling = true;
						poll.shouldHideResults = shouldHide;
						echo("A poll began")
					} else {
						echo("A field was left blank")
					}
				}
			}
		}
	});

	socket.on('golive', function(token){
		if(authRequest(token))
		{
			if(!isLive)
			{
				isLive = true;
				// Emit to all
				io.sockets.emit('live');
				echo("LIVE!");
			}
		} else {
			socket.emit('notauthed');
		}
	});

	socket.on('vote', function(response){
		if(!didUserVoteYet(socket))
		{
			responses.push(new Response(socket, response));
			echo("A user voted for {" + response + "} (" + responses.length + ")")

			// Push to all admin sockets
			if(shouldShowStatusBarsOnAdminGUI)
			{
				for(var i = 0; i < admin_sockets.length; i++)
				{
					admin_sockets[i].emit('pollupdate', generatePollUpdateString());
				}
			}
		} else {
			echo("User already voted");
		}

		updateConsoleUI();
	});

	socket.on('endpoll', function(token){
		if(authRequest(token))
		{
			if(isPolling)
			{
				isPolling = false;
				returnResults();
				responses.splice(0,responses.length);
				echo("ended poll")
			}
		} else {
			socket.emit('notauthed');
		}
	});

	// Video list handlers
	socket.on('getvideos', function() {
		sendVideos(socket);
	});

	socket.on('updatevideos', function(newvid,token){
		if(authRequest(token))
		{
			if(isValidVideoURL(newvid))
			{
				var contentBeforeUpdate = fs.readFileSync(videofile).toString();
				var after = contentBeforeUpdate + newvid + "\n";
				var options = { flag : 'w' };
    			fs.writeFile(videofile, after, options, function(err) {
        			if (err) throw err;
       					echo('file saved');
       					updateVideos();
   				});
			} else {
				echo("Video not valid")
				echo(newvid)
			}
		} else {
			socket.emit('notauthed');
		}
	});

	socket.on('removevideo', function(videoToDelete, token){
		if(authRequest(token))
		{
			var videoText = fs.readFileSync(videofile).toString();
			if(videoText.startsWith(videoToDelete))
			{
				var arr = videoText.split("\n")
				var newtext = "";
				for(var i = 1; i < arr.length; i++)
				{
					if(i != 1)
					{
						newtext += "\n" + arr[i];
					} else {
						newtext += arr[i];
					}
					
				}
			} else {
				var newtext = videoText.replace(videoToDelete, "").replace("\n\n", "\n");
			}
			
			var options = { flag : 'w' };
			fs.writeFile(videofile,newtext,options, function(err) {
				if(err)
				{
					throw err;
				} else {
					echo("file saved")
					updateVideos();
				}
			});
		} else {
			socket.emit('notauthed');
		}
	});

	// Recieved a new annoucement
	socket.on('newannouncement', function(creator,title,text,image,date,token){
		var ok = true;
		if(creator.includes(";"))
		{
			ok = false;
		}
		if(title.includes(";"))
		{
			ok = false;
		}
		if(text.includes(";"))
		{
			ok = false;			
		}
		if(image.includes(";"))
		{
			ok = false;			
		}
		if(date.includes(";"))
		{
			ok = false;			
		}
		echo("sent from admin")
		if(authRequest(token))
		{
			if(ok)
			{
				var a = new Announcement(text,title,creator,image,date)
				announcements.push(a)
				writeToAnnouncementsToFile();
				pushAnnouncementsToAll();
			} else {
				socket.emit("msg", "None of the fields can conatin a semicolor ( ; )")
			}
		} else {
			socket.emit('notauthed');
		}
	});

	socket.on('removeannouncement', function(creator,title,text,token){
		if(authRequest(token)) {
			var matches = 0;
			var matched = [];
			for(var i = 0; i < announcements.length; i++)
			{
				if(title == announcements[i].title)
				{
					if(creator == announcements[i].creator)
					{
						if(text == announcements[i].text)
						{
							matches++;

							announcements.splice(i,1);
						}
					}
				}
			}

			if(matches > 0)
			{
				writeToAnnouncementsToFile();
				pushAnnouncementsToAll();

				socket.emit("msg", matches + " records were removed"); // error just sends a alert()
			} else {
				socket.emit("msg", "No announcements were removed")
			}
		} else {
			socket.emit('notauthed');
		}
	});

	socket.on('getannouncements', function(){
		pushAnnouncements(socket);
	});

	socket.on('gooffair', function(token){
		if(authRequest(token))
		{
			isLive = false;
			io.sockets.emit("offair");
		} else {
			socket.emit("notauthed")
		}
	})

	// Sending of websites to clients
	socket.on('sendURL', function(urlToOpen, token) {
		if(authRequest(token)) {
			io.sockets.emit('openURL', urlToOpen)
		}
	})

	// Syncing
	socket.on('syncserver', function(syncdata,token){
		if(authRequest(token))
		{
			var sections = syncdata.split("<section ");
			for(var i = 0; i < sections.length; i++)
			{
				var section = sections[i];
				if(section.startsWith("announcements>"))
				{
					// Deal with the announcements
					section = replace("announcements>", "", section);
					console.log(section);
					writeToFile(section,announcementsfile);
					announcements = [];
					loadFromFile(announcementsfile,announcements);
					pushAnnouncementsToAll();
					console.log("updated announcements")
				}
				if(section.startsWith("videos>"))
				{
					section = replace("videos>", "", section);
					writeToFile(section, videofile)
					updateVideos();
					console.log("synced videos");
				}
			}
		} else {
			socket.emit('notauthed');
		}
	});

	socket.on('generatesyncfile', function(token){
		if(authRequest(token))
		{
			var syncfile = "<section announcements>" + getFileContents(announcementsfile) + "<section videos>" + getFileContents(videofile);
			socket.emit('syncfilecontents', syncfile);
		} else {
			socket.emit('notauthed');
		}
	});

	// Restart
	socket.on('restart', function(token) {
		if(authRequest(token))
		{
			socket.emit('msg', 'Server shutting down...It should be restarted by foreverjs');
			process.exit(99);
		} else {
			socket.emit('notauthed');
		}
	 });

	// Convienence
	socket.on('login', function(token)
	{
		if(authRequest(token))
		{
			socket.emit("loggedin")
			admin_sockets.push(socket);
		} else {
			socket.emit("notloggedin")
		}
	})
});
function updateVideos() {
	sendVideos("ALL");
}
function sendVideos(socket) {
	if(fs.readFileSync(videofile).toString() == null) { io.sockets.emit(""); return; }
	if(fs.readFileSync(videofile).toString() == "") { io.sockets.emit(""); return; } 
	var lines = fs.readFileSync(videofile).toString().split("\n");
	var ids = [];
	for(var i = 0; i < lines.length; i++)
	{
		var id = getVideoID(lines[i]);
		if(id != null)
		{
			ids[i] = id;
		}
	}
	echo(arrayToCSV(ids))
	if(socket == "ALL")
	{
		io.sockets.emit('videos', arrayToCSV(ids));
	} else {
		socket.emit('videos', arrayToCSV(ids));
	}
}

// Polling
function returnResults() {
	if(poll.hasCorrectAnswer())
	{
		io.sockets.emit('results', toPercent(percentCorrect()) + " of people guessed the correct answer which was " + poll.correct);
	} else {
		var p = percents();
		if(p != 0)
		{
			//io.sockets.emit('results', p[0] + " chose " + poll.choices[0] + "\n\n" + p[1] + " chose " + poll.choices[1] + "\n\n" + p[2] + " chose " + poll.choices[2] + "\n\n" + p[3] + " chose " + poll.choices[3]);
			// New
			io.sockets.emit('pollresults', poll.choices[0] + ":" + p[0] + "/" + poll.choices[1] + ":" + p[1] + "/" + poll.choices[2] + ":" + p[2] + "/" + poll.choices[3] + ":" + p[3], poll.prompt);
		} else {
			echo("A poll was run but nobody voted")
		}
	}
}

function generatePollUpdateString() {
	if(poll.hasCorrectAnswer())
	{
		var str = "";
		for(var i = 0; i < poll.choices.length; i++)
		{
			if(i != 0)
			{
				str += "<br>"
			}
			str += generateHTMLBootstrapProgressBar((poll.choices[i] == poll.correct),false,poll.choices[i],percents()[i]);
		}

		return str;
	} else {
		for(var i = 0; i < poll.choices.length; i++)
		{
			if(i != 0)
			{
				str += "<br>"
			}
			str += generateHTMLBootstrapProgressBar(false,true,poll.choices[i], percents()[i]);
		}
	}
}

function generateHTMLBootstrapProgressBar(isYellow, isBlue, text, progress) {
	if(isYellow == isBlue && isYellow == true) { return "<strong>An internal error occured</strong>"; }
	var bar = "<div class='progress'><div class='progress-bar";
	if(isYellow) { bar += " progress-bar-warning"}
	bar += "' role='progressbar' aria-valuenow='" + progress + "' aria-valuemin='0' aria-valuemax='100' style='width:" + progress + "'>" + text + "</div></div>"
	return bar;
}

function percentCorrect() {
	var correct = 0;
	var wrong = 0;
	for(var i = 0; i < responses.length; i++)
	{
		if(poll.check(responses[i].response))
		{
			correct++;
		} else {
			wrong++;
		}
	}
	var total = correct + wrong;
	return (correct / total);
}

function percents() {
	var one = 0;
	var two = 0;
	var three = 0;
	var four = 0;

	for(var i = 0; i < responses.length; i++)
	{
		switch (responses[i].response) {
			case poll.choices[0]: one++; break;
			case poll.choices[1]: two++; break;
			case poll.choices[2]: three++; break;
			case poll.choices[3]: four++; break;
		}
	}
	var total = one + two + three + four;
	if(total == 0) { return 0 }
	return [toPercent(one / total), toPercent(two / total), toPercent(three / total), toPercent(four / total)];
}

function toPercent(decimal) 
{
	return (decimal * 100) + "%";
}

// Auth
function authRequest(token)
{
	if(token == pwd)
	{
		return true;
	}

	return false;
}

// OOP
var Poll = function(answerchoices, index, prompt_) {
	this.shouldHideResults = false;
	this.choices = answerchoices;
	if(index == -1)
	{
		this.correct = -1;
	} else {
		this.correct = this.choices[index];
	}
	this.prompt = prompt_;
};
Poll.prototype.check = function (answer)
{
	if(this.correct == answer)
	{
		return true;
	}

	return false;
}
Poll.prototype.hasCorrectAnswer = function()
{
	if(this.correct == -1) { return false }
	return true;
}
Poll.prototype.pushAll = function ()
{
	io.sockets.emit('poll', arrayToCSV(this.choices), this.correct, this.prompt, this.shouldHideResults);
}

Poll.prototype.push = function (socket)
{
	socket.emit('poll', arrayToCSV(this.choices), this.correct, this.prompt, this.shouldHideResults);
}

var Response = function(s, r) {
	this.socket = s;
	this.response = r;
};

// Announcement Object
var Announcement = function(txt,ttle,c,img,d) {
	this.text = txt.replace(/\//g, "[slash]");
	this.title = ttle.replace("/", "[slash]");
	this.creator = c.replace("/", "[slash]");
	this.date = d;
	this.datestring = d;
	this.image = img.replace(/\//g, "[slash]");
};

Announcement.prototype.setid = function(idnum) {
	this.id = idnum;
}

Announcement.prototype.getid = function() {
	return this.id;
}

// Announcement helper
function loadFromFile(file,array)
{
	var lines = fs.readFileSync(file).toString().split("\n");
	for(var i = 0; i < lines.length; i++)
	{
		var line = replace("\n", "", lines[i]);
		var split = line.split("/");
		// Verify sytnax
		if(split.length == 5)
		{
			var announcement = new Announcement(split[2], split[1], split[0], split[3], split[4])
			announcements.push(announcement)
		} else {
			console.log("Line " + (i + 1) + " of announcements.txt was skipped due to invalid syntax, length = " + split.length);
			console.log(line);
		}
	}

	for(var i = 0; i < announcements.length; i++)
	{
		echo("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
		echo("Creator: " + announcements[i].creator);
		echo("Title: " + announcements[i].title);
		echo("Text: " + announcements[i].text);
		echo("Image Link: " + announcements[i].image);
		echo("Date: " + announcements[i].datestring)
	}
}

// Utility
function getFileContents(file)
{
	return fs.readFileSync(file).toString();
}

// announcement helper
function pushAnnouncements(socket)
{
	// Announcements are separated by ; and properties inside announcements are separated by /
	var string = "";
	for(var i = 0; i < announcements.length; i++)
	{
		var a = announcements[i];
		if(i == 0)
		{
			string = a.creator + "/" + a.title + "/" + a.text + "/" + a.date + "/" + a.image;
		} else {
			string += ";" + a.creator + "/" + a.title + "/" + a.text + "/" + a.date + "/" + a.image;
		}
	}
	if(socket == "ALL")
	{
		io.sockets.emit('announcements', string);
	} else {
		socket.emit('announcements', string);
	}
	echo("sent announcements");
}

function pushAnnouncementsToAll()
{
	pushAnnouncements("ALL");
}

function writeToAnnouncementsToFile()
{
	var filetext = "";
	for(var i = 0; i < announcements.length; i++)
	{
		var str = "\n";
		var a = announcements[i]; // anouncement object
		if(i == 0)
		{
			str = "";
		}
		str += a.creator + "/" + a.title + "/" + a.text + "/" + a.image + "/" + a.date;
		filetext += str;
	}
	echo("Contents of announcments file = " + filetext);
	writeToFile(filetext,announcementsfile);
}

// Utility methods
function indexOfSocket(socket)
{
	for(var i = 0; i < sockets.length; i++)
	{
		if(socket == sockets[i])
		{
			return true;
		}
	}

	return null;
}

function arrayToCSV (arr)
{
	var csv = "";
	for(var i = 0; i < arr.length; i++)
	{
		if(i != 0)
		{
			csv += ",";
		}

		csv += arr[i];
	}
	if(csv != "")
	{
		return csv;
	}
	return null;	
}
function didUserVoteYet(socket) {
	for(var i = 0; i < responses.length; i++)
	{
		if(responses[i].socket == socket)
		{
			return true;
		}
	}

	return false;
}

function getVideoID(ytURL)
{
	var str = ytURL.substr(ytURL.lastIndexOf("?v=") + 3);
	// Typically a YouTube ID is an 11 character alphanumeric string
	// with optional (+ and _) symbols.
	if(str.length == 11)
	{
		return str;
	} else {
		// If the extracted string is not 11 characters long, the URL
		// is probably either malformed or has added params (example: a playlist id)
		return null;
	}
}
function isValidVideoURL(ytURL)
{
	// This function just checks if the url is syntatically valid, not if a video actually 
	//...exists at that URL
	if(ytURL.startsWith("https://www.youtube.com/watch?v="))
	{
		if(ytURL.length == 43)
		{
			return true;
		}
	}

	return false;
}
function echo(text)
{
	if(debug)
	{
		echo(text);
	}
}
function clear()
{
	for(var i = 0; i < 100; i++) { console.log(""); }
}
function updateConsoleUI()
{
	
	if(isPolling)
	{
		echo("\r\rPolling: about " + responses.length + " votes");
	}
	if(isLive)
	{
		echo("\r\rBroadcast [LIVE] about " + sockets.length + " users are connected");
	}
}
function toCivilianTime(militaryTime, minute)
{
	if(militaryTime > 12) { 
		return militaryTime - 12 + ":" + minute + "PM"
	}

	return militaryTime + ":" + minute + "AM";
}
function writeToFile(txt,f)
{
	echo("text" + txt);
	echo("file" + f)
	var options = { flag : 'w' };
	fs.writeFile(f,txt,options, function(err) {
		if(err)
		{
			console.log("there was a problem writing to a file, you should probably check this")
			throw err;
		} else {
			echo("file saved")
		}
	});
}
function replace(string,withstring,instring)
{
	var parts = instring.split(string);
	var newstring = "";
	for(var i = 0; i < parts.length; i++)
	{
		if(i != 0)
		{
			newstring += withstring + parts[i];
		} else {
			newstring += parts[i];
		}
	}
	return newstring;
}
// Command line argument parsers
function shouldBeVerbose()
{
	var pref = false;
	process.argv.forEach(function (val, index, array) {
		if(val === "-v")
		{
			pref = true;
		}
	});
	return pref;
}
function shouldBeMainServer()
{
	var pref = false;
	process.argv.forEach(function (val, index, array) {
		if(val === "lan")
		{
			pref = true;
		}
	});

	return pref;
}
function isURLValid(input)
{
	var tlds = ["com", "net", "org", "edu", "gov", "io", "tv", "co", "us"]
	if(input.startsWith("http://") || input.startsWith("https://"))
	{
		if(input.substr(input.indexOf("/", 1)).contains("/"))
		{
			
		}
	}
}
