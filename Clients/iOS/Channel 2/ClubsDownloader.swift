//
//  ClubsDownloader.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/1/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import Foundation
import SwiftyJSON
class ClubsDownloader: NSObject {
    private var url:NSURL!;
    private var recursions = 0;
    internal var errors = false;
    private var API_KEY,API_SECRET,USER_ID:String!;
    init(vc:UIViewController) {
        super.init();
       /* Get the base server URL */
        if let baseUrlObject = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") {
            /* Convert it to a string */
            if let baseURL = baseUrlObject as? String {
                /* Add the filename for this API method and placeholder for URL params */
                var urlString = baseURL + "clubs.php?key={api_key}&secret={api_secret}&user={user_id}";
                
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
                if let id = getUserId(vc) {
                    USER_ID = id;
                    errors = false;
                } else {
                    errors = true;
                }
                
                /* If there have been no errors so far, put those values in the tempate url */
                if(!errors) {
                    urlString = urlString.stringByReplacingOccurrencesOfString("{api_key}", withString: API_KEY)
                    urlString = urlString.stringByReplacingOccurrencesOfString("{api_secret}", withString: API_SECRET)
                    urlString = urlString.stringByReplacingOccurrencesOfString("{user_id}", withString: USER_ID);
                    
                    if let u = NSURL(string: urlString) {
                        url = u;
                    }
                }
            }
        }
    }
    
    func getClubs() -> [Club] {
        if(!errors) {
            /* Get the data from the API */
            if let data = NSData(contentsOfURL: url) {
                let json = JSON(data: data);
                
                /* Loop through the json and make an array */
                var clubs = [Club]();
                for(key,sub) in json[]
                {
                    let club = Club();
                    club.id = sub["id"].intValue;
                    club.title = sub["title"].stringValue;
                    club.desc = sub["description"].stringValue;
                    club.admin = sub["admin"].stringValue;
                    club.privacy = sub["private"].boolValue;
                    club.membership = sub["membership"].intValue;
                    let urlstr = sub["image"].stringValue
                    if let url = NSURL(string: urlstr) {
                        if(UIApplication.sharedApplication().canOpenURL(url)) {
                            club.imageURL = url;
                        }
                    }
                    clubs.append(club)
                }
                
                return clubs;
            }
        }
        
        return [];
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
