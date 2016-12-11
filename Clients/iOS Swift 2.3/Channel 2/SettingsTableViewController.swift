//
//  SettingsTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/12/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import LNRSimpleNotifications
class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var cachingOn: UISwitch!
    @IBOutlet weak var cachedFileCount: UILabel!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var onThisDaySwitch: UISwitch!
    @IBOutlet weak var easterEggsSwitch: UISwitch!
    @IBOutlet weak var listupdatestatuswheel: UIActivityIndicatorView!
    @IBOutlet weak var listupdatestatus: UILabel!
    @IBOutlet weak var eventaction: UISegmentedControl!
    let defaults = NSUserDefaults.standardUserDefaults();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //eventaction.selectedSegmentIndex = defaults.integerForKey("announcementaction")
        easterEggsSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("eastereggs")
        onThisDaySwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("onThisDayStatus")
        animationSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("hpanimations")
        cachingOn.on = CacheManager.sharedInstance.cachingEnabled();
        nameTextField.placeholder = "Set your name";
        if let nameObj = NSUserDefaults.standardUserDefaults().valueForKey("user_name") {
            if let name = nameObj as? String {
                nameTextField.text = name;
            }
        }
        
        updateCacheCount()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCacheCount();
    }

    private func updateCacheCount() {
        cachedFileCount.text = "Cache contains " + String(CacheManager.sharedInstance.cacheSize()) + " files."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func filecachingchanged(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool((sender as! UISwitch).on, forKey: "caching")
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    @IBAction func clearfilecache(sender: AnyObject) {
        CacheManager.sharedInstance.clear { (itemsDeleted) in
            let manager = LNRNotificationManager();
            manager.showNotification("Cache Cleared!", body: "To completely stop using caching, turn it off in Settings", onTap: nil)
            self.updateCacheCount();
        }
    }
    @IBAction func eventactionchanged(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(eventaction.selectedSegmentIndex, forKey: "announcementaction")
        NSUserDefaults.standardUserDefaults().synchronize();
        eventaction.selectedSegmentIndex = defaults.integerForKey("announcementaction")
    }
    @IBAction func saveName(sender: AnyObject) {
        if let text = nameTextField.text {
            if text != "" {
                if(text.isAlphaNumeric()) {
                    NSUserDefaults.standardUserDefaults().setValue(text, forKey: "user_name")
                }
            }
        } else {
            let alertController = UIAlertController(title: "Name Invalid", message: "Please enter a name", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            (self as UIViewController).presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func animationToggled(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool((sender as! UISwitch).on, forKey: "hpanimations")
        NSUserDefaults.standardUserDefaults().synchronize();
    }
  
    @IBAction func onThisDayToggled(sender: AnyObject) {
        if let toggle = sender as? UISwitch {
            NSUserDefaults.standardUserDefaults().setBool(toggle.on, forKey: "onThisDayStatus");
            NSUserDefaults.standardUserDefaults().synchronize();
        } else {
            print("sender no good")
        }
    }
    
    @IBAction func easterEggSwitchChanged(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(easterEggsSwitch.on, forKey: "eastereggs");
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    // Website openers
    @IBAction func mywebsite(sender: AnyObject) {
        openurl("http://www.brendanmanning.com/");
    }
    @IBAction func lzrwebsite(sender: AnyObject) {
        openurl("https://github.com/LISNR/LNRSimpleNotifications/blob/master/LICENSE.txt")
    }
    @IBAction func iconwebsite(sender: AnyObject) {
        openurl("http://www.iconbeast.com/")
    }
    @IBAction func asyncwebsite(sender: AnyObject) {
        openurl("https://github.com/duemunk/Async/blob/master/LICENSE.txt");
    }
    @IBAction func popupwebsite(sender: AnyObject) {
        openurl("https://github.com/Orderella/PopupDialog/blob/master/LICENSE");
    }
    @IBAction func swiftyjsonwebsite(sender: AnyObject) {
        openurl("https://github.com/SwiftyJSON/SwiftyJSON/blob/master/LICENSE");
    }
    @IBAction func nowifiwebsite(sender: AnyObject) {
        openurl("https://thenounproject.com/term/wifi-problem/579316")
    }

    
    
   /* @IBAction func refreshOnThisDayList(sender: AnyObject) {
        var ok = false;
        Async.main {
            self.listupdatestatus.text = "Working on it!"
            self.listupdatestatuswheel.startAnimating();
            self.listupdatestatus.hidden = false;
            self.listupdatestatuswheel.hidden = false;
        }.background {
            let downloader = DayDownloader();
            let contents = downloader.get();
            if(downloader.worked)
            {
                if(contents != "")
                {
                    let fileManager = FM(l: "Documents", name: "OnThisDay.txt")
                    ok = fileManager.write(contents)
                }
            }
        }.main {
            self.listupdatestatuswheel.stopAnimating();
            self.listupdatestatuswheel.hidden = true;
            
            if(ok)
            {
                self.listupdatestatus.text = "Finished!"
            } else {
                self.listupdatestatus.text = "Failed!"
            }
        }.background(after: 10.0, chainingBlock: {
            self.listupdatestatus.hidden = true;
        })
    }*/
    @IBAction func fireBaseCredits(sender: AnyObject) {
        let alert = UIAlertController(title: "Firebase Sample Code Attribution Options", message: "Select an action below", preferredStyle: .Alert)
        let viewFileAction = UIAlertAction(title: "View Source Code", style: .Default, handler: { (_) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/firebase/quickstart-ios/blob/master/messaging/MessagingExampleSwift/AppDelegate.swift#L66-L89")!);
        })
        let readApacheLicenseAction = UIAlertAction(title: "Read License", style: .Default, handler: {(_) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "https://raw.githubusercontent.com/firebase/quickstart-ios/master/LICENSE")!);
        });
        let copyrightAction = UIAlertAction(title: "View Copyright", style: .Default, handler: {(_) -> Void in
                let ipalert = UIAlertController(title: "Copyright Information", message: "Copyright 2016 Google Inc.", preferredStyle: .Alert)
                let closeAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil);
                ipalert.addAction(closeAction);
            self.presentViewController(ipalert, animated: true, completion: {(_) -> Void in self.fireBaseCredits(self); });
        })
        let closeAction = UIAlertAction(title: "Close", style: .Default, handler: nil);
        alert.addActions([viewFileAction,readApacheLicenseAction,copyrightAction,closeAction]);
        alert.preferredAction = closeAction;
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func viewNotificationIconCredit(sender: AnyObject) {
        openurl("http://www.thenounproject.com");
    }
    
    @IBAction func viewPrivacyPolicy(sender: AnyObject) {
        if let base = NSUserDefaults.standardUserDefaults().stringForKey("phpserver") {
            openurl(base + "pages/privacy.html");
        }
    }
    // Utility method
    func openurl(url:String)
    {
        UIApplication.sharedApplication().openURL(NSURL(string: url)!);
    }
}
