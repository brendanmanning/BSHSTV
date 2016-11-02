//
//  ClubsCollectionViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/1/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import Async
import SwiftyJSON
class ClubsCollectionViewController: UICollectionViewController {
    var clubs = [Club]();
    var downloader:ClubsDownloader!;
    var API_KEY,API_SECRET,USER_ID,USER_NAME,CLUB_ID,CLUB_CODE:String!;
    var recursions = 0;
    var errors = false;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        collectionView?.reloadData();
        Async.background {
            self.downloader = ClubsDownloader(vc: self as UIViewController);
            self.clubs = self.downloader.getClubs();
            if(self.downloader.errors) {
                Async.main {
                    Popup().show("Error Getting Clubs", message: "Please try again", button: "Dismiss", viewController: self as UIViewController)
                }
            } else {
                Async.main {
                    self.collectionView?.reloadData();
                }
            }
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubs.count;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("clubc", forIndexPath: indexPath) as! ClubsCollectionViewCell
        cell.imageView.image = UIImage(named: "Loading");
        cell.titleLabel.text = clubs[indexPath.row].title
        cell.moderatorLabel.text = clubs[indexPath.row].admin
        
        Async.background {
            if let url = self.clubs[indexPath.row].imageURL {
                if let data = NSData(contentsOfURL: url) {
                    Async.main {
                        cell.imageView.image = UIImage(data: data);
                    }
                } else {
                    Async.main {
                        cell.imageView.image = UIImage(named: "ImageNotFound");
                    }
                }
            } else {
                Async.main {
                    cell.imageView.image = UIImage(named: "ImageNotFound");
                }
            }
        }
        
        return cell;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("clubc", forIndexPath: indexPath) as! ClubsCollectionViewCell
        
                /* Prepare the URL we'll use to enroll */
        if let baseUrlObject = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") {
            /* Convert it to a string */
            if let baseURL = baseUrlObject as? String {
                /* Add the filename for this API method and placeholder for URL params */
                var urlString = baseURL + "enroll.php?apikey={api_key}&apisecret={api_secret}&userid={user_id}&username={user_name}&clubid={club_id}&clubpassword={club_password}";
                
                /* Get those URL parameter values from preferences */
                
                // Get the api key
                if let keyObj = NSUserDefaults.standardUserDefaults().valueForKey("API_KEY") {
                    if let key = keyObj as? String {
                        API_KEY = key;
                    }
                }
                
                // Get the api secret
                if let secretObj = NSUserDefaults.standardUserDefaults().valueForKey("API_SECRET") {
                    if let secret = secretObj as? String {
                        API_SECRET = secret;
                    }
                }
                
                // Get the user id
                if let id = getUserId(self as UIViewController) {
                    USER_ID = id;
                    errors = false;
                } else {
                    print("e1")
                    errors = true;
                }
                
                // Get the user's name
                if let nameObj = NSUserDefaults.standardUserDefaults().valueForKey("user_name") {
                    USER_NAME = nameObj as! String; // If this fails, that's really bad so a crash would be better
                } else {
                    var setName = NameSetup().askForName(self as UIViewController);
                    if(!setName) {
                        return;
                    }
                }
                
                // Get the club id
                CLUB_ID = String(clubs[indexPath.row].id);
                
                // Ask the user for the club's password
                var setCode = false;
                let clubCodeAlert = UIAlertController(title: "Club password", message: "Please enter the code given to you by your moderator", preferredStyle: .Alert)
                clubCodeAlert.addTextFieldWithConfigurationHandler(
                    {(textField: UITextField!) in
                        textField.placeholder = "Club password here"
                })
                
                
                let action = UIAlertAction(title: "Submit", style: .Default, handler: {(_) -> Void in
                    if let textFields = clubCodeAlert.textFields{
                        let theTextFields = textFields as [UITextField]
                        let enteredText = theTextFields[0].text
                        
                        self.CLUB_CODE = enteredText!;
                        self.submit(urlString)
                    }
                });
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                
                clubCodeAlert.addAction(action)
                clubCodeAlert.preferredAction = action;
                
                
                self.presentViewController(clubCodeAlert, animated: true, completion: nil)
                
                
                
                /* If there have been no errors so far, put those values in the tempate url */
                
            }
        }
    }
    
    func submit(urlStr:String) {
        var urlString = urlStr;
        if((errors == false)) {
            urlString = urlString.stringByReplacingOccurrencesOfString("{api_key}", withString: API_KEY)
            urlString = urlString.stringByReplacingOccurrencesOfString("{api_secret}", withString: API_SECRET)
            urlString = urlString.stringByReplacingOccurrencesOfString("{user_id}", withString: USER_ID);
            urlString = urlString.stringByReplacingOccurrencesOfString("{user_name}", withString: USER_NAME)
            urlString = urlString.stringByReplacingOccurrencesOfString("{club_id}", withString: CLUB_ID)
            urlString = urlString.stringByReplacingOccurrencesOfString("{club_password}", withString: CLUB_CODE)
            
            urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            print(urlString)
            
            /* Now submit read the contents of the URL to get the status message from the server */
            var alertTitle = "No Internet!";
            var alertMessage = "You must be connected to the Internet to enroll in a course"
            if let url = NSURL(string: urlString) {
                if let data = NSData(contentsOfURL: url) {
                    let json = JSON(data: data);
                    
                    // Prepare the alert to tell the user if it worked
                    alertTitle = "Unknown Status";
                    alertMessage = "Unknown Message";
                    
                    if(json["status"] == "ok") {
                        alertTitle = "You're enrolled!"
                        alertMessage = json["message"].stringValue;
                    }
                    
                    if(json["status"] == "error") {
                        alertTitle = "Not enrolled!"
                        alertMessage = json["message"].stringValue;
                    }
                } else {
                    print("no data")
                }
            } else {
                print("url messed up")
            }
            
            let operationStatusAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
            let dismissOption = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            operationStatusAlert.addAction(dismissOption)
            
            (self as UIViewController).presentViewController(operationStatusAlert, animated: true, completion: nil)
        } else {
            print("there was some error")
            print(urlString)
        }
    }
    
    func getUserId(vc:UIViewController) -> String? {
        if let idObj = NSUserDefaults.standardUserDefaults().valueForKey("userid") {
            if let id = idObj as? String {
                return id;
            }
        } else {
            InitialSetup(vc: vc, message: "Getting some information from the server first", subMessage: "This will be quick", wait: false)
            recursions++;
            if(recursions < 3) {
                return getUserId(vc)
            }
        }
        
        return nil;
    }
}
