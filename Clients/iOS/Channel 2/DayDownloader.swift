//
//  DayDownloader.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/18/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import Foundation
import SwiftyJSON
/*
 * DayDownloader downloads a plain text file containing facts for every available day, and stores it in the app's documents directory
 *    - As such it is only run when no fact is available with the current file
 * TodayDownloader downloads information about events happening on any given day.
 *    - Data is returned in JSON format and is typed up online once a day, as such this is run whenever TodayViewController loads
 */
class DayDownloader: NSObject {
    private let host = String(NSUserDefaults.standardUserDefaults().valueForKey("phpserver")!);
    internal var worked = false;
    internal func get() -> String {
        if let url = NSURL(string: host + "/OnThisDay.txt")
        {
            do {
                let str = try String(contentsOfURL: url)
                //print("String: " + str)
                self.worked = true;
                return str
            } catch {
                return "";
            }
        } else {
            return "";
        }
    }
}

class TodayDownloder:NSObject {
    internal func get() -> [TodayItem] {
        if let hostObj = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") {
            if let h = hostObj as? String {
                let host = h + "today.php";
                if let url = NSURL(string: host) {
                    if let data = NSData(contentsOfURL: url) {
                        let json = JSON(data: data)
                        // Prepare an object for each value returned
                        let songObject = TodayItem();
                        songObject.title = "Song of the Day";
                        songObject.content = json[0]["song"].stringValue + " by " + json[0]["artist"].stringValue;
                        
                        let gameObj = TodayItem();
                        gameObj.title = "Today's Games"
                        gameObj.content = json[0]["game"].stringValue + " at " + json[0]["location"].stringValue + ". Time: " + json[0]["time"].stringValue;
                        
                        var arr = [TodayItem]();
                        if(songObject.content != " by ")
                        {
                            arr.append(songObject)
                        }
                        
                        if(gameObj.content == " at . Time: ")
                        {
                            gameObj.content = "No games today :("
                        }
                        
                        arr.append(gameObj)
                        
                        return arr;
                    }
                }
            }
        }
        return [];
    }
}
