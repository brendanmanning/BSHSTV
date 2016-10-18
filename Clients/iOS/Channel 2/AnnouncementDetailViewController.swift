//
//  AnnouncementDetailViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 10/16/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON
class AnnouncementDetailViewController: UIViewController {

    @IBOutlet var peopleCountLabel: UILabel!
    @IBOutlet var creatorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var fullTextView: UITextView!
    @IBOutlet var iconImageView: UIImageView!
    var isGoing = false;
    var id = -1;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Get array of information from NSUserDefaults
        if let informationArrayNS = NSUserDefaults.standardUserDefaults().objectForKey("announcementsDetailArray") as? [AnyObject] {
            if let informationArray = informationArrayNS as? [NSString] {
                titleLabel.text = informationArray[0] as String;
                dateLabel.text = informationArray[1] as String;
                creatorLabel.text = informationArray[2] as String;
                fullTextView.text = informationArray[3] as String;
                peopleCountLabel.text = informationArray[4] as String;
                id = Int(informationArray[5] as String)!;
            } else {
                print("f1")
            }
        } else {
            print("f2")
        }
        let file = FM(l:"Documents", name: "announcementDetailImage.png")
        if let data = file.read()
        {
            iconImageView.image = UIImage(data: data);
        } else {
            print("f3")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func setAnnouncementTitle(t:String) {
        self.titleLabel.text = t;
    }
    
   override func previewActionItems() -> [UIPreviewActionItem] {
        if(!attendingEvent(id)) {
            let attendAction = UIPreviewAction(title: "I'm going!", style: .Default) { (action: UIPreviewAction, vc: UIViewController) -> Void in
                Async.background {
                    self.sayImGoingToEvent(self.id)
                }
            }
            
            return [attendAction];
        }
    
        return [];
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }
    
    func sayImGoingToEvent(eventId:Int) -> Bool
    {
        if let eventsAlreadyGoingTo = NSUserDefaults.standardUserDefaults().objectForKey("alreadyGoingToArray") as? [String]
        {
            /* The app saves an array containing every event the user has already committed to. This way they can't say they're going twice.
             * The server would stop that anyway
             */
            if(!attendingEvent(eventId))
            {
                /* Safely get the API key and secret */
                if let key = NSUserDefaults.standardUserDefaults().valueForKey("API_KEY") as? String {
                    if let secret = NSUserDefaults.standardUserDefaults().valueForKey("API_SECRET") as? String {
                        /* Get the base url of the server */
                        if let server = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") as? String {
                            /* Prepare a template we'll insert the real values into */
                            var template = server + "imgoing.php?key={api_key}&secret={api_secret}&event={event}&user={user}";
                            
                            /* Insert the real values */
                            var realUrl = template;
                            realUrl = realUrl.stringByReplacingOccurrencesOfString("{api_key}", withString: key)
                            realUrl = realUrl.stringByReplacingOccurrencesOfString("{api_secret}", withString: secret)
                            realUrl = realUrl.stringByReplacingOccurrencesOfString("{event}", withString: String(eventId))
                            
                            /* A user id may not be setup yet (If the user didn't have internet when they installed the app) */
                            if let useridobject = NSUserDefaults.standardUserDefaults().valueForKey("userid") {
                                if let userid = useridobject as? String {
                                    /* Put in the final value */
                                    realUrl = realUrl.stringByReplacingOccurrencesOfString("{user}", withString: userid)
                                    
                                    /* If we get to this point, we're okay to make our request */
                                    if let url = NSURL(string: realUrl) {
                                        /* Actually make the request */
                                        if let data = NSData(contentsOfURL: url) {
                                            /* Cast it to JSON */
                                            let json = JSON(data: data);
                                            /* Now read the status key */
                                            if json["status"].stringValue == "ok" {
                                                
                                                /* Sync the array */
                                                var newarr = eventsAlreadyGoingTo;
                                                newarr.append(String(eventId))
                                                NSUserDefaults.standardUserDefaults().setObject(newarr, forKey: "alreadyGoingToArray")
                                                NSUserDefaults.standardUserDefaults().synchronize();
                                                return true;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return false;
    }
    
    func attendingEvent(eventId: Int) -> Bool {
        if let eventsAlreadyGoingTo = NSUserDefaults.standardUserDefaults().objectForKey("alreadyGoingToArray") as? [String]
        {
            /* IF THE USER TRIED TO VOTE ON SOMETHING THEY ALREADY VOTED ON, DON'T BOTHER TO SHOW A POPUP */
            
            return (eventsAlreadyGoingTo.contains(String(eventId)))
        }
        
        return false;
    }
}
