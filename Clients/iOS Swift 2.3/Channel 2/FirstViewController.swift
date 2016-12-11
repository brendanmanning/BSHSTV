//
//  FirstViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/9/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import GoogleMobileAds

class FirstViewController: UIViewController {

    @IBOutlet weak var upsellButton: UIButton!
    @IBOutlet var swipeUpRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var adView: GADBannerView!
    @IBOutlet weak var clubButton: UIBarButtonItem!
    
    // Banner
    @IBOutlet weak var banner: UITextField!
    // Current Poll Object
    //var poll:Poll!
    
    // Interface Builder
    @IBOutlet var logo: UIImageView!
    @IBOutlet var top: UILabel!
    @IBOutlet weak var swipeupimage: UIImageView!
    
    // Popup
    var isShowingPopup = false;
    
    // LineByLineDownloader
    var downloader:LineByLineDownloader!;
    
    var isfirstview = true;
    
    // Setup object
    var setup:IDSetup!;
    
    // Upsell button index
    var upsellButtonIndex = -1;
    
    let upsellItems = ["notification:Get snow delay alerts", "notification:Get urgent school updates", "feedback:Give feedback"];
    var approvedNotifications = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UpgradeManager.sharedInstance.proEnabled()) {
            applyProTheme();
        }
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("hpanimations")) {
            
            top.alpha = 0;
            logo.alpha = 0;
            upsellButton.alpha = 0;
            let imageY = swipeupimage.frame.origin.y
            
            swipeupimage.frame.origin.y = view.frame.height + (swipeupimage.frame.height / 2);
        
            UIView.animateWithDuration(2.0, animations: {
                self.top.alpha = 1;
                self.logo.alpha = 1;
                self.upsellButton.alpha = 1;
                //self.bottom.frame.origin.x = bottomX;
                self.swipeupimage.frame.origin.y = imageY;
            });
        }
        
        //Setup the UI Before updating via sockets
        top.text = "Channel 2"
        /*if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
             bottom.text = "Use the tabs below to navigate. 👇 Portrait mode works best.";
        } else {
            bottom.text = "Use the tabs below to navigate. 👇 Landscape mode works best.";
        }*/
        
        self.logo.image = UIImage(named: "green_logo");
        
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
                        
                    } else {
                        if NSUserDefaults.standardUserDefaults().boolForKey("agreedToPrivacyPolicy") {
                            /* Load the banner ad */
                            self.adView.adUnitID = "{AD_UNIT_ID}"
                            self.adView.rootViewController = self
                            let req = GADRequest();
                            req.testDevices = [kGADSimulatorID]
                            req.keywords = [];
                            self.adView.loadRequest(req)
                        }
                    }
                } catch {}
            }
        }
        
        Async.background {
            /* Make sure the app is on an accepted version */
            let versionChecker = FeatureChecker();
            if(!versionChecker.check(String(NSUserDefaults.standardUserDefaults().valueForKey("version_feature")!))) {
                let forcedChecker = FeatureChecker();
                let forceUpdate = forcedChecker.check("ForcedUpgrades")
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
        
        /* Is the clubs feature enabled?
        self.clubButton.title = "";
        self.clubButton.enabled = false;
        Async.background {
            let clubChecker = FeatureChecker();
            if(clubChecker.check("clubs")) {
                Async.main {
                    
                }
            }
        } */
        
        self.clubButton.enabled = true;
        self.clubButton.title = "Clubs";
        
        nextButton();
        // Refresh the button text every 5 seconds
        NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: #selector(FirstViewController.nextButton), userInfo: nil, repeats: true)
    }
    
    func nextButton() {
        var ok = false;
        repeat {
            if((upsellButtonIndex == -1) || (upsellButtonIndex == (upsellItems.count - 1))){
                upsellButtonIndex = 0;
            } else {
                upsellButtonIndex += 1;
            }
        
            ok = true;
        
            upsellButton.setTitle(upsellItems[upsellButtonIndex].componentsSeparatedByString(":")[1], forState: .Normal);
            
            if(NotificationSettings.sharedInstance.isRegistered() || approvedNotifications) {
                if upsellItems[upsellButtonIndex].componentsSeparatedByString(":")[0] == "notification" {
                    ok = false;
                    print("Choosing a different option...")
                }
            }
        } while(!ok);
        
        if let title = upsellButton.currentTitle {
            print("Current title = " + title)
        } else {
            print("Current title is nil");
        }
        print("Chose " + upsellItems[upsellButtonIndex].componentsSeparatedByString(":")[1])
    }
    
    @IBAction func upsellButton(sender: AnyObject) {
        if(upsellItems[upsellButtonIndex].hasPrefix("notification:")) {
            approvedNotifications = true;
            Async.background {
                NotificationSettings.sharedInstance.register();
                NotificationSettings.sharedInstance.saveRegistrationStatus();
            }
            nextButton();
            NotificationSettings.sharedInstance.requestNotificationsPermissionsFromLocalDevice();
        } else if(upsellItems[upsellButtonIndex].hasPrefix("feedback:")) {
            let webview = WebViewController();
            webview.url = NSUserDefaults.standardUserDefaults().stringForKey("phpserver")! + "pages/feedback.php";
            self.showViewController(webview, sender: self)
        }
    }
    override func viewDidAppear(animated: Bool) {
        /* Make sure the user has agreed to the privacy policy */
        self.privacyPolicyCheck({(agreed: Bool) -> Void in
            self.setup = IDSetup();
            if(!self.setup.isSetup()) {
                self.setup.generateUserID();
            }
        });
        
        /* Yes, yes, yes, I know it will fall through the first time because this won't
         * evaulate to true until the completion handler above runs, but the user will
         * probably appreciate having at least their first use be ad-free */
        
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("agreedToPrivacyPolicy")) {
            
            if(!UpgradeManager.sharedInstance.proEnabled() && NSUserDefaults.standardUserDefaults().boolForKey("saidNoThisSession") == false) {
                Async.background {
                    while(!UpgradeManager.sharedInstance.ready()) {}
                    
                    let checker = FeatureChecker();
                    checker.assumeFalse();
                    if(checker.check("pro")) {
                        Async.main {
                        
                        
                            /* Ask the user if they want to upgrade */
                            let popup = UIAlertController(title: "Make Channel 2 Cooler?", message: "Get a cool theme for this app!", preferredStyle: .Alert)
                            let yesButton = UIAlertAction(title: "Yes", style: .Default, handler: ({ (_) -> Void in
                                UpgradeManager.sharedInstance.upgrade(self)
                                if(UpgradeManager.sharedInstance.proEnabled()) {
                                    self.applyProTheme();
                                }
                            }));
                            let noButton = UIAlertAction(title: "No", style: .Default, handler: ({ (_) -> Void in
                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "saidNoThisSession")
                            }));
                        
                            popup.addActions([noButton,yesButton])
                        
                            self.presentViewController(popup, animated: true, completion: nil)
                            //UpgradeManager.sharedInstance.upgrade(self)
                        }
                    }
                }
            }
            
            /* Handle a url if there is one */
            //handleUrl();
        }
    }
    
    func handleUrl() {
        if let urlObject = NSUserDefaults.standardUserDefaults().valueForKey("__url")
        {
            if let url = urlObject as? String
            {
                let type = url.componentsSeparatedByString(":")[0];
                let argument = url.componentsSeparatedByString(":")[1];
                
                if type == "club" {
                  
                }
            }
        }
    }
    
    func applyProTheme() {
        self.view.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        //self.view.backgroundColor = UIColor.grayColor();
        self.top.textColor = UIColor.greenColor();
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
        let myUtterance = AVSpeechUtterance(string: "O Canada! Our home and native land!True patriot love in all thy sons command. With glowing hearts we see thee rise,The True North strong and free! From far and wide, O Canada, We stand on guard for thee. God keep our land, glorious and free! O Canada, we stand on guard for thee; O Canada, we stand on guard for thee. O Canada! Where pines and maples grow, Great prairies spread and Lordly rivers flow! How dear to us thy broad domain, From East to Western sea! The land of hope for all who toil, The true North strong and free!God keep our land, glorious and free. O Canada, we stand on guard for thee! O Canada, we stand on guard for thee! O Canada! Beneath thy shining skies, May Stalwart sons, and gentle maidens rise. To keep thee steadfast thro' the years, From East to Western sea. Our own beloved native land, Our true North strong and free! God keep our land, glorious and free. O Canada, we stand on guard for thee! O Canada, we stand on guard for thee! Ruler supreme, who hearest humble prayer, Hold our Dominion, in thy loving care. Help us to find, O God, in thee, A lasting rich reward. As waiting for the better day, We ever stand on guard. God keep our land, glorious and free. O Canada, we stand on guard for thee! O Canada, we stand on guard for thee!");
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
                        let myUtterance = AVSpeechUtterance(string: "A long time ago in a galaxy far far away.")
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

    private func privacyPolicyCheck(completion: (agreed: Bool) -> Void) {
        if(!NSUserDefaults.standardUserDefaults().boolForKey("agreedToPrivacyPolicy")) {
            
            askUserToAgreeToPrivacyPolicy(completion);
        }
    }
    
    private func askUserToAgreeToPrivacyPolicy(completion: (agreed: Bool) -> Void) {
        var agreed = false;
        let privacPolicyAlertController = UIAlertController(title: "Privacy Policy", message: "Your use of this application is subject to its privacy policy", preferredStyle: .Alert)
        let readAction = UIAlertAction(title: "View Privacy Policy", style: .Default, handler: {(_) -> Void in
           self.performSegueWithIdentifier("segueToPrivacyPolicy", sender: self)
        });
    
        let agreeAction = UIAlertAction(title: "Agree and Continue", style: .Default, handler: {(_) -> Void in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "agreedToPrivacyPolicy");
            agreed = true;
        })
    
        privacPolicyAlertController.addAction(readAction)
        privacPolicyAlertController.addAction(agreeAction)
        privacPolicyAlertController.preferredAction = agreeAction;
        
        presentViewController(privacPolicyAlertController, animated: true, completion: { (_) -> Void in
            if (!agreed) {
                self.askUserToAgreeToPrivacyPolicy(completion)
            } else {
                completion(agreed: true);
            }
        })
    }
}
