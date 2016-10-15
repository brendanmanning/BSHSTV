//
//  OnlinePoll.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/20/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class OnlinePoll: NSObject {
    internal var title:String!;
    internal var prompt:String!
    internal var desc:String!;
    internal var options = [PollOption]();
    internal var id:String!;
    internal var totalvotes = 0;
    internal func optionsToStringArray() -> [String] {
        var toreturn = [String]();
        for o in options {
            toreturn.append(o.text)
        }
        return toreturn;
    }
    
    internal func fillOptions(fromStringArray:[String])
    {
        if(fromStringArray.count == 4)
        {
            var index = 1;
            options.removeAll()
            for string in fromStringArray
            {
                let option = PollOption();
                option.number = index;
                option.text = fromStringArray[index-1];
                options.append(option)
                index += 1;
            }
        }
    }
    
    /*internal func setVotesFromOptionNumber(votes:Int,number:Int)
    {
        options[number-1].votes = votes;
    }*/
    
    internal func choice(number:Int) -> String
    {
        return options[number-1].text;
    }
    
    internal func choices() ->[String]
    {
        var arr = [String]();
        for o in options {
            arr.append(o.text);
        }
        
        return arr;
    }
    
    internal func setVotes(atIndex:Int,percent:Float)
    {
        options[atIndex-1].percent = percent;
    }
    
    internal func getPercents() -> [Float]
    {
        return [options[0].percent, options[1].percent, options[2].percent, options[3].percent];
    }
}

class PollOption:NSObject {
    internal var number = -1;
    internal var text = String();
    internal var percent:Float = 0;
}
