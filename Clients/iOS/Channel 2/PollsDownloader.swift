//
//  PollsDownloader.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/21/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON

class PollsDownloader: NSObject {
    internal func get() throws -> [OnlinePoll] {
        // Prepare the url action
        let urlAsString = String(NSUserDefaults.standardUserDefaults().valueForKey("phpserver")!)
        let fullUrl = urlAsString + "polls.php";
        let url = NSURL(string: fullUrl)
            
        // Get the data
        if let data = NSData(contentsOfURL: url!) {
            let json = JSON(data: data);
        
            // Iterate through the data
            var array = [OnlinePoll]();
            for(key,subJson) in json[]
            {
                // Create and append a new poll
                let poll = OnlinePoll();
                poll.desc = subJson["prompt"].stringValue;
                poll.id = subJson["id"].stringValue;
                poll.prompt = subJson["description"].stringValue;
                array.append(poll)
            }
        
            // Return the data
            return array;
        } else {
            throw NetworkError.Failed;
        }
    }
}
