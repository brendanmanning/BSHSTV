//
//  ClubDetailViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/19/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import MessageUI
class ClubDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var clubDescriptionLabel: UILabel!
    //@IBOutlet weak var clubAdminLabel: UILabel!
    @IBOutlet weak var clubImageView: UIImageView!
    @IBOutlet weak var leaveClubButton: UIButton!
    @IBOutlet weak var clubMeetingsTable: UITableView!
    @IBOutlet weak var titleItem: UINavigationItem!
    
    private var meetings = [Announcement]();
    
    private var clubname = "";
    private var clubdescription = "";
    private var clubadmin = "";
    private var clubid = -2;
    private var adminEmail:String!;
    private var club:Club!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.clubname;

        // Add pre-set data from segue
        clubNameLabel.text = clubname;
        clubDescriptionLabel.text = clubdescription;
        
        // Ask the user to enable push notifications is they are disabled
        print(NSUserDefaults.standardUserDefaults().boolForKey("registeredForFcm"));
        if (NSUserDefaults.standardUserDefaults().boolForKey("registeredForFcm") == false) {
            self.performSegueWithIdentifier("askForNotifications", sender: self)
        }
        
        // Load the image from the Documents directory
        Async.background {
            let manager = FM(l: "Documents", name: "clubImage.jpeg");
            if let data = manager.read() {
                if let image = UIImage(data: data) {
                    if let imgview = self.clubImageView {
                        Async.main {
                            imgview.image = image;
                        }
                    }
                }
            }
        }
    
        // Change the appearance for pro theme
        self.view.backgroundColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) : UIColor.whiteColor();
        if(UpgradeManager.sharedInstance.proEnabled()) {
            clubNameLabel.textColor = UIColor.whiteColor();
            clubDescriptionLabel.textColor = UIColor.whiteColor();
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func leaveClub() {
        
        Popup().confirm("You will have to rejoin " + self.clubname + " if you change your mind.", viewController: self, preferred: 1, desctructive: [1], yesOption: "Yes", noOption: "Cancel", completion: {(confirmed:Bool) -> Void in
            if(confirmed) {
                var (success, message) = self.club.unenroll()
                let alert = UIAlertController(title: "Unenroll " + ((success) ? "Okay!" : "Failed!"), message: message, preferredStyle: .Alert)
                let close = UIAlertAction(title: "OK", style: .Default, handler: {
                (_) -> Void in
                    if success {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
                alert.addAction(close)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    @IBAction func sendEmailToMod(sender: AnyObject) {
        let composer = MFMailComposeViewController();
        composer.mailComposeDelegate = self;
        composer.setToRecipients([self.adminEmail!]);
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(composer, animated: true, completion: nil)
        }
    }
    
    func setAnnouncement(club:Club) {
        self.clubname = club.title;
        self.clubdescription = club.desc;
        self.clubadmin = club.admin;
        self.clubid = club.id!;
        self.adminEmail = club.email!;
        self.club = club;
    }

    // MARK: Utility methods
    func formatDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "EEEE M/d";
        return dateFormatter.stringFromDate(date);
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segueToMeetings") {
            (segue.destinationViewController as! ClubMeetingsTableViewController).club = self.clubid;
        }
    }
    
    
    /*func configuredMailComposeViewController(to:String) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController();
        composer.delegate = self as UIViewController;
        
        composer.setToRecipients([to])
        
        return composer;
    }*/
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if result == MFMailComposeResult.Failed {
            let errorAlert = UIAlertController(title: "Email Error", message: "Sorry your email was not sent", preferredStyle: .Alert)
            let dismiss = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            errorAlert.addAction(dismiss)
            errorAlert.preferredAction = dismiss;
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
