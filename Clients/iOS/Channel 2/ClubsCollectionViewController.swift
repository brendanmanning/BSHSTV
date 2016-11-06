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
    var getter:JSONGetter!;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        collectionView?.reloadData();
        Async.background {
            self.getData()
        }.main {
                self.collectionView?.reloadData();
        }
    }
    
    func getData() {
        self.downloader = ClubsDownloader(vc: self as UIViewController);
        self.clubs = self.downloader.getClubs();
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
        
        if(clubs[indexPath.row].membership == 1) {
            cell.titleLabel.font = UIFont.boldSystemFontOfSize(16)
        } else {
            cell.titleLabel.font = UIFont.systemFontOfSize(16)
        }
        
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
        
        if(self.clubs[indexPath.row].membership == 1) {
            /* Prepare the confirmation alert */
            let alert = UIAlertController(title: "Leave " + clubs[indexPath.row].title + "?", message: "Are you sure?", preferredStyle: .Alert)
            
            /* Prepare the confirm action */
            var success = false;
            
            let leaveAction = UIAlertAction(title: "Leave", style: .Destructive, handler: { (action: UIAlertAction) -> Void in
                let (unenrolled,message) = self.clubs[indexPath.row].unenroll();
                
                // Reload the collection view
                self.collectionView?.reloadData();
                
                // Make an alert to tell the user if it worked
                Popup().system((unenrolled) ? "Unenrolled!" : "Error Unenrolling", message: message, button: "Dismiss", viewController: self as UIViewController)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(leaveAction)
            
            alert.preferredAction = leaveAction;
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if(self.clubs[indexPath.row].membership == 0) {
            
            /* Make sure the user's name is set */
            if NSUserDefaults.standardUserDefaults().objectForKey("user_name") == nil {
                // Setup the user's name
                let ns = NameSetup();
                let gaveName = ns.askForName(self as UIViewController)
                if(!gaveName) {
                    return;
                }
            }
            
            var clubCodeAlert:UIAlertController!;
            
            if(self.clubs[indexPath.row].privacy) {
                var setCode = false;
                clubCodeAlert = UIAlertController(title: "Club password", message: "Please enter the code given to you by your moderator", preferredStyle: .Alert)
                clubCodeAlert.addTextFieldWithConfigurationHandler({(textField:UITextField) -> Void in
                    textField.placeholder = "Join code here";
                });
            } else {
                clubCodeAlert = UIAlertController(title: "Join " + self.clubs[indexPath.row].title + "?", message: nil, preferredStyle: .Alert)
            }
                
            let action = UIAlertAction(title: (self.clubs[indexPath.row].privacy) ? "Submit" : "Yes", style: .Default, handler: {[weak self](action:UIAlertAction) in
                var enteredText = "";
                if(self!.clubs[indexPath.row].privacy) {
                    if let textFields = clubCodeAlert.textFields {
                        let theTextFields = textFields as [UITextField]
                        enteredText = theTextFields[(clubCodeAlert.textFields?.count)! - 1].text!
                    }
                } else {
                    enteredText = "__no_pass_required__"
                }
                
                // Enroll and get the result
                let (enrolled,message) = self!.clubs[indexPath.row].enroll(enteredText)
                    
                // Reload the collection view
                self!.collectionView?.reloadData();
                    
                Popup().system((enrolled) ? "Enrolled!" : "Error Enrolling", message: message, button: "Dismiss", viewController: self! as UIViewController)
            });
                
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            
            clubCodeAlert.addAction(cancelAction)
            clubCodeAlert.addAction(action)
            clubCodeAlert.preferredAction = action;
                
                
            self.presentViewController(clubCodeAlert, animated: true, completion: nil)
        }
    }
    
    func submit(urlStr:String, cell: UICollectionViewCell?, getter: JSONGetter) {
        var urlString = urlStr;
        if((errors == false)) {
            /*urlString = urlString.stringByReplacingOccurrencesOfString("{api_key}", withString: API_KEY)
            urlString = urlString.stringByReplacingOccurrencesOfString("{api_secret}", withString: API_SECRET)
            urlString = urlString.stringByReplacingOccurrencesOfString("{user_id}", withString: USER_ID);
            urlString = urlString.stringByReplacingOccurrencesOfString("{user_name}", withString: USER_NAME)
            urlString = urlString.stringByReplacingOccurrencesOfString("{club_id}", withString: CLUB_ID)
            urlString = urlString.stringByReplacingOccurrencesOfString("{club_password}", withString: CLUB_CODE)
            
            urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            print(urlString)
            */
            /* Now submit read the contents of the URL to get the status message from the server */
            var alertTitle = "No Internet!";
            var alertMessage = "You must be connected to the Internet to enroll in a course"

            let operationStatusAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
            do {
                if let json = try getter.json() {
                    
                    // Prepare the alert to tell the user if it worked
                    alertTitle = "Unknown Status";
                    alertMessage = "Unknown Message";
                    
                    if(json["status"] == "ok") {
                        alertTitle = "You're enrolled!"
                        alertMessage = json["message"].stringValue;
                        (cell! as! ClubsCollectionViewCell).titleLabel.font = UIFont.boldSystemFontOfSize(16)
                    }
                    
                    if(json["status"] == "error") {
                        alertTitle = "Not enrolled!"
                        alertMessage = json["message"].stringValue;
                    }
                } else {
                    alertTitle = "Error";
                    alertMessage = "A server error occured (Code CCVC 1)";
                }
            } catch (JSONError.Failed) {
                alertTitle = "Error";
                alertMessage = "A server error occured (Code CCVC 2)";
            } catch (JSONError.URLNotSet) {
                alertTitle = "Error";
                alertMessage = "A server error occured (Code CCVC 3)";
            } catch (JSONError.URLNotValid) {
                alertTitle = "Error";
                alertMessage = "A server error occured (Code CCVC 4)";
            } catch {
                alertTitle = "Error";
                alertMessage = "A server error occured (Code CCVC 5)";
            }
            
            operationStatusAlert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil));
            
            (self as UIViewController).presentViewController(operationStatusAlert, animated: true, completion: nil);
        } else {
            print("there was some error")
            print(urlString)
        }
    }
}
