//
//  SettingsTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/12/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
class SettingsTableViewController: UITableViewController {

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
        
        nameTextField.placeholder = "Set your name";
        if let nameObj = NSUserDefaults.standardUserDefaults().valueForKey("user_name") {
            if let name = nameObj as? String {
                nameTextField.text = name;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func eventactionchanged(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(eventaction.selectedSegmentIndex, forKey: "announcementaction")
        NSUserDefaults.standardUserDefaults().synchronize();
        eventaction.selectedSegmentIndex = defaults.integerForKey("announcementaction")
    }
    @IBAction func saveName(sender: AnyObject) {
        if let text = nameTextField.text {
            NSUserDefaults.standardUserDefaults().setValue(text, forKey: "user_name")
        } else {
            let alertController = UIAlertController(title: "Name Invalid", message: "Please enter a name", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            (self as UIViewController).presentViewController(alertController, animated: true, completion: nil)
        }
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
    @IBAction func viewNotificationIconCredit(sender: AnyObject) {
        openurl("http://www.thenounproject.com");
    }
    
    // Utility method
    func openurl(url:String)
    {
        UIApplication.sharedApplication().openURL(NSURL(string: url)!);
    }
}
