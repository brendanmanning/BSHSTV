//
//  FirstViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/9/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import PopupDialog
import AVFoundation
class FirstViewController: UIViewController {

    // Banner
    @IBOutlet weak var banner: UITextField!
    // Current Poll Object
    var poll:Poll!
    
    // Socket URLs
   /* let LAN_IP = NSURL(string: String(NSUserDefaults.standardUserDefaults().valueForKey("lanip")))
    let WAN_IP = NSURL(string: String(NSUserDefaults.standardUserDefaults().valueForKey("hostname")))
    
    /* See if we can access a small static file from the server */
    let LAN_TEST_PAGE = NSURL(string: "http://192.168.1.1" + "/hello.html")
    let WAN_TEST_PAGE = NSURL(string: String(NSUserDefaults.standardUserDefaults().valueForKey("hostname")) + "/hello.html")

    
    // Socket connection
    var socket:SocketIOClient!;
    var isConnectedToMainServer = false;
    
    // Socket connection statuses
    var lanConnectionFailed = false;
    var wanConnectionFailed = false;*/
    
    // Interface Builder
    @IBOutlet weak var reconnectButton: UIButton!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var top: UILabel!
    @IBOutlet var bottom: UILabel!
    @IBOutlet weak var swipeupimage: UIImageView!
    
    // Popup
    var isShowingPopup = false;
    var popup:PopupDialog!;
    var queue = [PopupDialog]();
    
    // LineByLineDownloader
    var downloader:LineByLineDownloader!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topY = top.frame.origin.y;
        let logoX = logo.frame.origin.x;
        let bottomX = bottom.frame.origin.x;
        let imageY = swipeupimage.frame.origin.y;
        
        top.frame.origin.y = 0 - (top.frame.height / 2);
        logo.frame.origin.x = 0 - (logo.frame.width / 2);
        bottom.frame.origin.x = view.frame.width + (bottom.frame.width / 2);
        swipeupimage.frame.origin.y = view.frame.height + (swipeupimage.frame.height / 2);
        
        UIView.animateWithDuration(2.0, animations: {
            self.top.frame.origin.y = topY;
            self.logo.frame.origin.x = logoX;
            self.bottom.frame.origin.x = bottomX;
            self.swipeupimage.frame.origin.y = imageY;
        });
        
        // Setup the UI Before updating via sockets
        top.text = "Channel 2"
        bottom.text = "Use the tabs below to navigate. 👇 Landscape mode works best.";
        
        self.logo.image = UIImage(named: "green_logo");
        // Reconnect button setup
        reconnectButton.enabled = false;
        reconnectButton.hidden = true;
        
        
        // Request any important information for the top bar (esp school closings)
        banner.alpha = 0;
        Async.background {
            if let host = NSUserDefaults.standardUserDefaults().valueForKey("phpserver")
            {
                let url = NSURL(string: (host as! String) + "banner.php")
                do {
                    let b = try String(contentsOfURL: url!)
                    if(b.lowercaseString != "nothing")
                    {
                        Async.main {
                            self.banner.text = b;
                            UIView.animateWithDuration(0.75, animations: {
                                self.banner.alpha = 1;
                            })
                        }
                        
                    }
                } catch {}
            }
        }
        
        
        /* 
 
            SERVER CONNECTIONS DISABLED
 
 
    */
        
        
        
        // Server connection
       // self.connectToServers()
    }
    
    @IBAction func reconnectToServer(sender: AnyObject) {
        /*if((self.socket) != nil)
        {
            if(self.socket.status != SocketIOClientStatus.Connected && self.socket.status != SocketIOClientStatus.Connecting)
            {
                self.connectToServers();
            }
        } else {
            self.connectToServers();
        }*/
    }
    
    func connectToServers() {
       /* let tester = SocketTester(lan: LAN_TEST_PAGE!, fallback: WAN_TEST_PAGE!);
        Async.background {
            if(tester.test())
            {
                Async.main {
                    self.reconnectButton.hidden = true;
                    self.reconnectButton.enabled = false;
                }
                
                self.socket = tester.getWorkingSocket();
                self.socketHandlers()
                self.socket.connect();
            } else {
                //TEMP: Try again with port 443
                let newtest = SocketTester(lan: self.LAN_TEST_PAGE!, fallback: NSURL(string: "http://ch2.brendanmanning.com:443/hello.html")!)
                self.bottom.text = "Trying port 443";
                if(!newtest.test())
                {
                    
                
                // UI must be updated from the main thread
                Async.main {
                    self.top.text = "No servers reachable"
                    self.bottom.text = "Your are offline"
                }
                
                
                Async.main {
                    self.reconnectButton.alpha = 0.0;
                    
                    self.reconnectButton.hidden = false;
                    self.reconnectButton.enabled = true;
                    
                    UIView.animateWithDuration(1.0, animations: {
                        self.reconnectButton.alpha = 1.0;
                    })
                }
                } else {
                    Async.main {
                        self.top.text = "443 Connected"
                        self.bottom.text = "PORT 443 WORKS!";
                        self.socket = newtest.getWorkingSocket();
                        self.socketHandlers();
                        self.socket.connect();
                        
                        let alert = UIAlertController(title: "Connected", message: "You are connected to port 443", preferredStyle: .Alert)
                        let dismiss = UIAlertAction(title: "Yay!", style: .Default, handler: nil)
                        alert.addAction(dismiss)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            
            Async.main {
                NSUserDefaults.standardUserDefaults().setInteger(tester.socketNumber(), forKey: "servernumber");
            }
        }*/
    }
    // Socket handlers
    func socketHandlers() {
        /*self.socket.on("poll") {[weak self] data, ack in
            let components = String(data[0]).componentsSeparatedByString(",")
            self!.poll = Poll(_choices: components, _correct: data[1].integerValue, _prompt: (data[2] as? String)!);
            self!.displayPollPopup()
        }
        
        self.socket.on("live") {[weak self] data, ack in
            self!.logo.image = UIImage(named: "green_logo");
            self!.top.text = "Channel 2: ON AIR!"
            self!.bottom.text = "Thanks for watching!"
        }
        
        self.socket.on("offair") {[weak self] data, ack in
            self!.logo.image = UIImage(named: "red_logo");
            self!.top.text = "Channel 2"
            self!.bottom.text = "Broadcast off air"
        }
        
        self.socket.on("results") {[weak self] data, ack in
            self!.popupmessage("The vote ended!", msg: data[0] as! String);
        }
        
        /*self.socket.on("videos") {[weak self] data, ack in
            NSUserDefaults.standardUserDefaults().setObject((data[0] as! String), forKey: "videos");
            NSNotificationCenter.defaultCenter().postNotificationName("com.brendanmanning.Channel-2.updatevideos", object: self)
        }*/
        self.socket.on("hello") {[weak self] data, ack in
            self!.bottom.text = "Stay tuned for broadcast!";
        }
        
        self.socket.on("announcements") {[weak self] data, ack in
            NSUserDefaults.standardUserDefaults().setValue(String(data[0]), forKey: "announcements")
            NSNotificationCenter.defaultCenter().postNotificationName("com.brendanmanning.Channel-2.announcements", object: self)
        }
        
        self.socket.on("pollresults") {[weak self] data, ack in
            let dataAsString = data[0] as! String;
            // The event will emit something like this:
            //Choice1:33.333%/Choice 2:25%
            var values = [Double]();
            var labels = [String]();
            for choice in dataAsString.stringByReplacingOccurrencesOfString("%", withString: "").componentsSeparatedByString("/")
            {
                let choiceTitle = choice.componentsSeparatedByString(":")[0];
                let choiceValue = choice.componentsSeparatedByString(":")[1];
                
                values.append((choiceValue as NSString).doubleValue);
                labels.append(choiceTitle);
            }
            
            let graphVC = GraphViewController();
            graphVC.datalabels = labels;
            graphVC.datavals = values;
            graphVC.pollprompt = data[1] as! String;
            
            self?.presentViewController(graphVC, animated: true, completion: nil)
        }
         */
    }
    
    // Poll UI Methods
    func displayPollPopup() {
        /*
        var popupTitle = "poll!";
        if(poll.hasCorrectAnswers())
        {
            popupTitle = "question!"
        }
        popup = PopupDialog(title: "Answer this " + popupTitle, message: poll.getprompt());
        let buttonOne = DefaultButton(title: poll.getchoices()[0], action: { self.vote(0) });
        let buttonTwo = DefaultButton(title: poll.getchoices()[1], action: { self.vote(1) });
        let buttonThree = DefaultButton(title: poll.getchoices()[2], action: { self.vote(2) });
        let buttonFour = DefaultButton(title: poll.getchoices()[3], action: { self.vote(3) });
        
        popup.addButtons([buttonOne, buttonTwo, buttonThree, buttonFour]);
        if(self.presentedViewController != nil)
        {
            self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(popup, animated: true, completion:nil);
 */
    }
    
    func popupmessage (t: String, msg:String) {
        popup = PopupDialog(title: t, message: msg);
        let button = DefaultButton(title: "Okay", action: nil)
        popup.addButton(button);
        if(self.presentedViewController != nil)
        {
            self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(popup, animated: true, completion:nil);
        Async.background(after: 7.0)
        {
            self.popup.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func vote(choice:Int) {
       // self.socket.emit("vote", poll.getchoices()[choice]);
    }
    
    // Obligatory override method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            if(NSUserDefaults.standardUserDefaults().boolForKey("eastereggs")) {
                promptForEasterEgg();
            }
        }
    }
    
    func readOhCanada() {
        let synth = AVSpeechSynthesizer()
        var myUtterance = AVSpeechUtterance(string: "O Canada! Our home and native land!True patriot love in all thy sons command. With glowing hearts we see thee rise,The True North strong and free! From far and wide, O Canada, We stand on guard for thee. God keep our land, glorious and free! O Canada, we stand on guard for thee; O Canada, we stand on guard for thee. O Canada! Where pines and maples grow, Great prairies spread and Lordly rivers flow! How dear to us thy broad domain, From East to Western sea! The land of hope for all who toil, The true North strong and free!God keep our land, glorious and free. O Canada, we stand on guard for thee! O Canada, we stand on guard for thee! O Canada! Beneath thy shining skies, May Stalwart sons, and gentle maidens rise. To keep thee steadfast thro' the years, From East to Western sea. Our own beloved native land, Our true North strong and free! God keep our land, glorious and free. O Canada, we stand on guard for thee! O Canada, we stand on guard for thee! Ruler supreme, who hearest humble prayer, Hold our Dominion, in thy loving care. Help us to find, O God, in thee, A lasting rich reward. As waiting for the better day, We ever stand on guard. God keep our land, glorious and free. O Canada, we stand on guard for thee! O Canada, we stand on guard for thee!");
        myUtterance.rate = 0.9;
        synth.speakUtterance(myUtterance)
    }
    
    func promptForEasterEgg() {
        let alertController = UIAlertController(title: "Easter Egg Prompt", message: "Enter an easter egg code here", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Easter Egg"
        })
        
        
        let action = UIAlertAction(title: "Submit", style: .Default, handler: {[weak self](paramAction:UIAlertAction!) in
                if let textFields = alertController.textFields{
                    let theTextFields = textFields as [UITextField]
                    let enteredText = theTextFields[0].text
                    if enteredText?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") == "tedcruz" {
                        self!.readOhCanada();
                    }
                    if enteredText?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") == "loser" {
                        UIApplication.sharedApplication().openURL(NSURL(string: "https://en.wikipedia.org/wiki/Kanye_West")!);
                    }
                    if enteredText?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") == "vader" {
                        let synth = AVSpeechSynthesizer()
                        var myUtterance = AVSpeechUtterance(string: "A long time ago in a galaxy far far away.")
                        myUtterance.rate = 0.25;
                        synth.speakUtterance(myUtterance)
                    }
                    if enteredText?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") == "orange" {
                        UIApplication.sharedApplication().openURL(NSURL(string: "https://en.wikipedia.org/wiki/Donald_Trump")!);
                    }
                    
                    if enteredText?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") == "crooked" {
                        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.hillaryclinton.com/")!)
                    }
                    
                    if enteredText?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") == "themeaningoflife" {
                        UIApplication.sharedApplication().openURL(NSURL(string: "https://en.wikipedia.org/wiki/42_(number)")!);
                    }
                    
                    if enteredText?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") == "meaningoflife" {
                        UIApplication.sharedApplication().openURL(NSURL(string: "https://en.wikipedia.org/wiki/42_(number)")!);
                    }
                }
        })
    
        let closeAction = UIAlertAction(title: "Close", style: .Default, handler: nil)
        
        alertController.addAction(closeAction)
        alertController.addAction(action)
        alertController.preferredAction = action;
        self.presentViewController(alertController,animated: true,completion: nil)
    
    }
}

class Poll: NSObject {
    private var choices:[String]!;
    private var correct:Int!
    private var prompt = "";
    init(_choices:[String], _correct:Int, _prompt:String)
    {
        self.choices = _choices;
        self.correct = _correct;
        self.prompt = _prompt;
    }
    
    internal func hasCorrectAnswers() -> Bool
    {
        if(self.correct != -1) { return true }
        return false;
    }
    
    internal func isCorrect(selection: String) -> Bool
    {
        if(self.choices[correct] == selection) { return true }
        return false;
    }
    
    internal func getchoices() -> [String] {
        return self.choices;
    }
    
    internal func getprompt() -> String {
        return self.prompt;
    }
}