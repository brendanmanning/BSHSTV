//
//  AnnouncementDownloader.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/18/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON


class AnnouncementDownloader: NSObject {
    internal var vc:UIViewController!;
    internal func get() throws -> [Announcement] {
        // Prepare the url
        var API_URL = String(NSUserDefaults.standardUserDefaults().valueForKey("phpserver")!) + "clubannouncements.php";
        
        let idinfo = IDSetup();
        if let id = idinfo.getUserID() {
            API_URL += "?userid=" + id;
        } else {
            if idinfo.generateUserID() {
                if let id = idinfo.getUserID() {
                    API_URL += "?userid=" + id;
                }
            }
        }
        var ok = false;
        let error = false;
        var loops = 0;

        
        // Get it's contents
        if let apiContents = NSData(contentsOfURL: NSURL(string: API_URL)!) {
            guard !error else {
                Popup().show("Error", message: "We couldn't get the announcements because you have to have Internet connection. (Error: AD 1)", button: "Dismiss", viewController: vc);
                throw NetworkError.Failed;
            }
            // Prepare SwiftyJSON
            let json = JSON(data: apiContents)
            
            // Parse the JSON
            var announcements = [Announcement]();
            for(key,subJson) in json[] {
                let announcement = Announcement();
                let title = subJson["title"].stringValue;
                announcement.eventtitle = title;
                let creator = subJson["creator"].stringValue
                announcement.creator = creator;
                let image = subJson["image"].stringValue
                announcement.imagelink = image;
                let date = subJson["date"].stringValue
                announcement.date = date;
                let text = subJson["text"].stringValue
                announcement.text = text;
                announcement.id = Int(subJson["id"].stringValue);
                
                if(subJson["hideCheckins"].boolValue) {
                    announcement.peopleGoing = -1;
                } else {
                    announcement.peopleGoing = subJson["checkins"].intValue;
                }
                
                announcements.append(announcement)
            }
            
            // Return the new announcements array
            return announcements;
        } else {
            throw NetworkError.Failed;
        }
    }
}
