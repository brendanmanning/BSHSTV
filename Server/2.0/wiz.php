<?php
	include 'config.php';
	session_start();
	/* Session variables we write to */
	/*
	 - song
	 - artist
	 - step
	 - authed
	 - game
	 - location
	 - time
	 - banner
	 */


	if(!isset($_GET['step']))
	{

		if(!isset($_POST['pwd'])) {
			//echo "Step parameter was not set. Resetting progress because we can assume it's a new day";
			//echo "<br>If you did not mean to go here, unfortunately any wizard progress you made is lost.<br>Please don't make the same mistake again";
			if($_SESSION['authed']) {
				if(1 == 1) {
					echo '<html><head><title>Finish Wizard</title><link rel="stylesheet" type="text/css" href="mainstyle.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" /></head><body>';
					echo "<h1>Current Session Data</h1>";
					echo "Step: " . $_SESSION['step'];
					echo "<br>Artist: " . $_SESSION['artist'];
					echo "<br>Song: " . $_SESSION['song'];
					if($_SESSION['game'] == "") {
						echo "<br>Game: none";
					} else {
						echo "<br>Game: " . $_SESSION['game'];
					}
					if($_SESSION['location'] == "") {
						echo "<br>Game Location: none"; 
					} else {
						echo "<br>Game Location: " . $_SESSION['location'];
					}
					if($_SESSION['time'] == "")
					{
						echo "<br>Time: N/A";
					} else {
						echo "<br>Time: " . $_SESSION['time'];
					}
					if($_SESSION['banner'] == "" || $_SESSION['banner'] == "nothing") {
						echo "<br>No banner";
					} else {
						echo "<br>Banner: " . $_SESSION['banner'];
					}
			
					echo '
				<form action="saveDatabaseInfo.php" method="POST">
					<center>
						<strong>Update the following Information?</strong>
						<br>
						<button class="primary outline" type="submit">Yes</button>  <a href="handlers/resetData.php">No, reset the data</a>
					</center>
				</form>';
			
					echo "</body></html>";
				}
			} else {
				header("Location: wizard.php?login");
			}
		} else {
			if($_POST['pwd'] == $password) {
				$_SESSION['authed'] = true;
				header("Location: wiz.php?step=-1");
			} else {
				header("Location: wizard.php?wrong");
			}
		}
	} else {
		if($_SESSION['authed'] == false) {
			header("Location: wizard.php?login");
			die("");
		}
	
		if($_GET['step'] == 'end') {
			echo '<html><head><title>Done!</title>
					<link rel="stylesheet" type="text/css" href="mainstyle.css">
					<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/mu/0.3.0/mu.min.css" />
				</head>
				<body>
					<h2>You are setup! :)</h2>
					<i>Looking to add more? Add videos, announcements, and polls below</i>
					<form action="addannouncement.php">
						<button type="submit" class="primary">Add an Announcement</button>
					</form>
					<form action="addvideo.php>
						<button type="submit" class="primary">Add a video</button>
					</form>';	
		} else if($_GET['step'] == -1) {
			echo "<body>";
			include 'views/progressHeader.php';
			echo "</body>";
			include 'views/welcome.html';
		} else if($_GET['step'] == 0) {
			echo "<body>";
			include 'views/progressHeader.php';
			echo "</body>";
			include 'views/updateDailyInfo.html';
		} else if($_GET['step'] == 1) {
			echo "<body>";
			include 'views/progressHeader.php';
			echo "</body>";
			include 'views/addSportsGame.html';
		} else if($_GET['step'] == 2) {
			echo "<body>";
			include 'views/progressHeader.php';
			echo "</body>";
			include 'views/updateBannerInfo.html';
		} else {
			header("Location: wiz.php");
		}
		

	}
?>