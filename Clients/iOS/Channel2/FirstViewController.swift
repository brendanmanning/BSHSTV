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
                    if(b.lowercaseString != "nothing" && b != "")
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
    }
    
    @IBAction func reconnectToServer(sender: AnyObject) {
    }
    
    func connectToServers() {
    }
    // Socket handlers
    func socketHandlers() {
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