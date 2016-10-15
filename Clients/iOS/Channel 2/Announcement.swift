//
//  Announcement.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/13/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import Foundation

class Announcement: NSObject {
    internal var creator:String!;
    internal var eventtitle:String!;
    internal var text:String!;
    internal var date:String!;
    internal var imagelink:String!;
    internal var datevalid = true;
    internal var id:Int!;
    internal var peopleGoing:Int!;
    internal func getDate() -> NSDate
    {
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "M-d-yyyy-h-m-a";
        if let date = formatter.dateFromString(self.date)
        {
            return date;
        } else {
            datevalid = false;
            return NSDate(timeIntervalSince1970: 0); // January 1st 1970
        }
    }
    
    internal func dateValid() -> Bool {
        let formatter = NSDateFormatter();
        formatter.dateFormat = "M-d-yyyy-h-m-a";
        if let date = formatter.dateFromString(self.date)
        {
            if date.earlierDate(NSDate(timeIntervalSince1970: 162000)).isEqualToDate(date) {
                return false;
            }
        }
        
        return true;
    }
}
