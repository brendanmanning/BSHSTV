//
//  PollDownloader.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/21/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON

class PollDownloader: NSObject {
    internal func get(id:Int) throws -> OnlinePoll
    {
        // Prepare the url action
        let urlAsString = String(NSUserDefaults.standardUserDefaults().valueForKey("phpserver")!)
        let pollId = String(NSUserDefaults.standardUserDefaults().valueForKey("pollid")!);
        let fullUrl = urlAsString + "getpoll.php?id=" + pollId;
        let url = NSURL(string: fullUrl)
            
        // Get the data
        if let data = NSData(contentsOfURL: url!) {
            let json = JSON(data: data);
                
            // Iterate through the data
            let poll = OnlinePoll();
            for(key,subJson) in json[]
            {
                // Handle the metadata first
                poll.desc = subJson["info"]["description"].stringValue;
                poll.prompt = subJson["info"]["prompt"].stringValue;
                poll.id = subJson["info"]["id"].stringValue;
                
                // Deal with the choices as a string array
                var choices = [String]();
                choices.append(subJson["choices"]["1"].stringValue);
                choices.append(subJson["choices"]["2"].stringValue);
                choices.append(subJson["choices"]["3"].stringValue);
                choices.append(subJson["choices"]["4"].stringValue);
                
                // Now fill the poll object with them
                poll.fillOptions(choices)
            }
            
            // Prepare a second url action to get the voting information
            let secondUrlAsString = String(NSUserDefaults.standardUserDefaults().valueForKey("phpserver")!)
            let secondFullUrl = secondUrlAsString + "getpollvotes.php?id=" + pollId;
            let secondUrl = NSURL(string: secondFullUrl);
            
            // Get the second set of data
            if let data = NSData(contentsOfURL: secondUrl!)
            {
                let json = JSON(data: data);
                
                // Deal with the data
                poll.setVotes(1, percent: Float(json["1"].stringValue)!);
                poll.setVotes(2, percent: Float(json["2"].stringValue)!);
                poll.setVotes(3, percent: Float(json["3"].stringValue)!);
                poll.setVotes(4, percent: Float(json["4"].stringValue)!);
                poll.totalvotes = Int(json["total"].stringValue)!;
            } else {
                throw NetworkError.Failed;
            }
            
            // Return the data
            return poll;
        } else {
            throw NetworkError.Failed;
        }
    }
}

