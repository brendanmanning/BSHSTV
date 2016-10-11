//
//  CacheManager.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/26/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import Foundation
class CacheManager: NSObject {

    internal func load(imageName:String) -> UIImage?
    {
        // Look at list of cached files
        let cached = NSUserDefaults.standardUserDefaults().objectForKey("cachedImaged") as! [String];
        var cachedFileName = String();
        var foundFileInCache = false;
        for cachedfile in cached {
            if(cachedfile == imageName)
            {
                cachedFileName = cachedfile;
                foundFileInCache = true;
                break;
            }
        }
        
        return nil;
    }
    
    
    // Helper funtion - https://www.hackingwithswift.com/example-code/media/how-to-save-a-uiimage-to-a-file-using-uiimagepngrepresentation
    func getDocumentsDirectory() -> NSURL? {
        return NSURL(string: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]);
    }
}
