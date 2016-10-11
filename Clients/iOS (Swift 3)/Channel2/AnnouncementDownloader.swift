//
//  AnnouncementDownloader.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/18/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON
import PopupDialog

class AnnouncementDownloader: NSObject {
    internal func get() throws -> [Announcement] {
        // Prepare the url
        let API_URL = String(NSUserDefaults.standardUserDefaults().valueForKey("phpserver")!) + "announcements.php";
            
        // Get it's contents
        if let apiContents = NSData(contentsOfURL: NSURL(string: API_URL)!) {
            
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
                
                announcements.append(announcement)
            }
            
            // Return the new announcements array
            return announcements;
        } else {
            throw NetworkError.Failed;
        }
    }
}
