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
import SwiftyJSON
class FirstViewController: UIViewController {

    @IBOutlet var swipeUpRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var songOfTheDay: UITextField!
    @IBOutlet weak var musicIcon: UIImageView!
    // Banner
    @IBOutlet weak var banner: UITextField!
    // Current Poll Object
    //var poll:Poll!
    
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
    
    var isfirstview = true;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songOfTheDay.alpha = 0;
        musicIcon.alpha = 0;
        songOfTheDay.hidden = true;
        musicIcon.hidden = true;
        
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
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
             bottom.text = "Use the tabs below to navigate. 👇 Portrait mode works best.";
        } else {
            bottom.text = "Use the tabs below to navigate. Landscape mode works best.";
        }
        
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
        
        Async.background {
            /* Make sure the app is on an accepted version */
            let versionChecker = FeatureChecker();
            if(!versionChecker.check(String(NSUserDefaults.standardUserDefaults().valueForKey("version_feature")!))) {
                var forceUpdate:Bool = versionChecker.check("ForcedUpgrades")
                Async.main {
                    self.swipeUpRecognizer.enabled = false;
                    var selections = [LockViewControllerOption]();
                    let updateOption = LockViewControllerOption(optionTitle: "Update BSHS TV", optionUrl: "http://bshstv.com/update/index.php")
                    selections.append(updateOption)
                    if(!forceUpdate) {
                        let closeOption = LockViewControllerOption(optionTitle: "Dismiss", optionUrl: nil)
                        selections.append(closeOption);
                    }
                    let lvc = LockViewController(viewController: self, selections: selections, lockedTitle: "App update needed", lockedMessage: versionChecker.message);
                    lvc.present();
                    self.swipeUpRecognizer.enabled = true;
                }
            }
        }
        
        /*Async.background {
            if let urlBase = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") as? String {
                if let url = NSURL(string: (urlBase) + "today.php") {
                    if let data = NSData(contentsOfURL: url) {
                        let json = JSON(data: data);
                        if json["song"].stringValue != "" && json["artist"].stringValue != "" {
                            Async.main {
                                self.songOfTheDay.text = json["song"].stringValue + " by " + json["artist"].stringValue;
                                UIView.animateWithDuration(2.0, animations: {
                                    self.songOfTheDay.alpha = 1;
                                    self.musicIcon.alpha = 1;
                                })
                                print("fading up...")
                            }
                            
                        }
                    }
                }
            }
        }*/
        Async.main {
            self.privacyPolicyCheck();
            }.main {
        let setup = InitialSetup(vc: self as UIViewController, message: "Performing initial setup", subMessage: "This is normally very quick", wait: false);
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        /* Make sure the user has agreed to the privacy policy */
        if(!isfirstview) {
            privacyPolicyCheck();
        } else {
            isfirstview = false;
        }
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

    private func privacyPolicyCheck() {
        if(!NSUserDefaults.standardUserDefaults().boolForKey("agreedToPrivacyPolicy")) {
            
            askUserToAgreeToPrivacyPolicy();
        }
    }
    
    private func askUserToAgreeToPrivacyPolicy() {
        let privacPolicyAlertController = UIAlertController(title: "Privacy Policy", message: "Your use of this application is subject to its privacy policy", preferredStyle: .Alert)
        let readAction = UIAlertAction(title: "View Privacy Policy", style: .Default, handler: {(_) -> Void in
           self.performSegueWithIdentifier("segueToPrivacyPolicy", sender: self)
        });
    
        let agreeAction = UIAlertAction(title: "Agree and Continue", style: .Default, handler: {(_) -> Void in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "agreedToPrivacyPolicy");
        })
    
        privacPolicyAlertController.addAction(readAction)
        privacPolicyAlertController.addAction(agreeAction)
        privacPolicyAlertController.preferredAction = agreeAction;
        
        presentViewController(privacPolicyAlertController, animated: true, completion: {(_) -> Void in
            self.privacyPolicyCheck();
        })
    }
}