//
//  OnlineVoter.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/22/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON

class OnlineVoter: NSObject {
    private var id:String!;
    
    init(poll:String)
    {
        self.id = poll;
    }
    
    internal func vote(choice:Int) -> Bool
    {
        return self.doVote(choice)
    }
    
    private func doVote(number:Int) -> Bool
    {
        // Programatically create the url
        var API_URL = String(NSUserDefaults.standardUserDefaults().valueForKey("phpserver")!)
        API_URL += "vote.php?id=" + String(self.id) + "&choice=" + String(number);
        
        // Prepare the get JSON from the result
        let url = NSURL(string: API_URL)
        
        // Get the JSON
        if let data = NSData(contentsOfURL: url!)
        {
            let json = JSON(data: data)
            if(json["status"].stringValue == "ok")
            {
                return true;
            }
        }
        
        return false;
    }
    
    internal func remember()
    {
        var pollsVotedIn = NSUserDefaults.standardUserDefaults().objectForKey("votedin") as! [String]
        pollsVotedIn.append(String(self.id));
        NSUserDefaults.standardUserDefaults().setObject(pollsVotedIn, forKey: "votedin")
    }
    
    internal func didAlreadyVotedInPoll() -> Bool {
        let pollsVotedIn = NSUserDefaults.standardUserDefaults().objectForKey("votedin") as! [String]
        for p in pollsVotedIn {
            if p == String(self.id) {
                return true;
            }
        }
        
        return false;
    }
}
