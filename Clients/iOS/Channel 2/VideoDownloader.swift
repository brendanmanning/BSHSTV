//
//  VideoDownloader.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/18/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class VideoDownloader: NSObject {
    override init()
    {
        // Make the api url
        let API_URL = String(NSUserDefaults.standardUserDefaults().valueForKey("phpserver")!) + "videos.php";
        print(API_URL);
        // Try to get the contents of that url
        do {
            let videos = try String(contentsOfURL: NSURL(string: API_URL)!);
            if((videos != "") && (videos.lowercaseString != "Error"))
            {
                NSUserDefaults.standardUserDefaults().setValue(videos, forKey: "videos")
                print("downloaded...")
            }
        } catch {
            
        }
    }
}
