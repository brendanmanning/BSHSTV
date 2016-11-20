//
//  Club.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/1/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class Club: NSObject {
    internal var title:String!;
    internal var desc: String!;
    internal var admin:String!;
    internal var id:Int!;
    internal var membership:Int!;
    internal var privacy = true;
    internal var imageURL:NSURL!;
    internal var image:UIImage!;
    
    private var getter:JSONGetter!;
    func initilize() {
        if let baseUrlObject = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") {
            /* Convert it to a string */
            if let baseURL = baseUrlObject as? String {
                /* Add the filename for this API method and placeholder for URL params */
                let urlString = baseURL + "enroll.php?apikey={api_key}&apisecret={api_secret}&userid={user_id}&username={user_name}&clubid={club_id}&clubpassword={club_password}";
                
                /* Use JSON helper class */
                getter = JSONGetter(url: urlString);
                
                /* Get those URL parameter values from preferences */
                
                // Get the api key
                if let keyObj = NSUserDefaults.standardUserDefaults().valueForKey("API_KEY") {
                    if let key = keyObj as? String {
                        //API_KEY = key;
                        getter.bindParam("{api_key}", value: key);
                    }
                }
                
                // Get the api secret
                if let secretObj = NSUserDefaults.standardUserDefaults().valueForKey("API_SECRET") {
                    if let secret = secretObj as? String {
                        //API_SECRET = secret;
                        getter.bindParam("{api_secret}", value: secret);
                    }
                }
                
                // Get the user id
                // Get the user id
                let idInfo = IDSetup();
                if(idInfo.isSetup()) {
                    if let user_id = idInfo.getUserID() {
                        getter.bindParam("{user_id}", value: user_id)
                    }
                }
                
                if let nameObj = NSUserDefaults.standardUserDefaults().valueForKey("user_name") {
                    getter.bindParam("{user_name}", value: nameObj as! String)
                }
                
                getter.bindParam("{club_id}", value: String(self.id))
                print(id)
            }
        }
    }
    
    internal func enroll(pass:String) -> (Bool,String) {
        guard let jsongetter = self.getter else {
            return (false, "An internal error occured (Code: Club.swift 2)");
        }
        
        // Reset the URL
        self.initilize();
        
        // Bind the club's password
        jsongetter.bindParam("{club_password}", value: pass)
        
        do {
            if let json = try jsongetter.json() {
                if json["status"] == "ok" {
                    self.membership = 1;
                    return (true, json["message"].stringValue);
                } else if json["status"] == "error" {
                    return (false, json["message"].stringValue)
                }
            }
        } catch {}
        
        return (false, "An unknown error occured (Code: Club.swift 3)");
    }
    
    internal func unenroll() -> (Bool,String) {
        guard let jsongetter = self.getter else {
            return (false, "Error code: Club.swift 1");
        }
        
        // Resent the url
        self.initilize();
        
        // Set the unenroll parameter
        jsongetter.addSuffix("&unenroll")
        
        do {
            if let json = try jsongetter.json() {
                if json["status"] == "ok" {
                    self.membership = 0;
                    return (true, json["message"].stringValue);
                }
            }
        } catch {}
        
        return (false, "An unknown error occured");
    }
}
