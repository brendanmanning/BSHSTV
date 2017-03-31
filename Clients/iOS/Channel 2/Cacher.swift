//
//  Cacher.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/26/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class Cache: NSObject {
    
    private let cachePrefix = "cached_"; // Any string you want, designates which images are cached files
    
    internal func cachedVersionExists(url:NSURL) -> Bool {
        // Break down the url
        var fileName = cachePrefix + url.absoluteString!;
        fileName = fileName.superSanitize();
        let file = FM(l:"Documents", name: fileName);
        return file.exists();
    }
    
    internal func cache(image:UIImage, from:NSURL) {
        // Make sure caching in enabled
        if(CacheManager.sharedInstance.cachingEnabled()) {
            // Convert the url to a safe string
            var fileName = cachePrefix + from.absoluteString!.superSanitize();
            // Debugging...
            print("Caching to [" + fileName + "]")
            // Save the file
            let file = FM(l: "Documents", name:fileName)
            file.writeData(UIImageJPEGRepresentation(image, 1.0)!);
            // Save the file's name to an NSUserDefaults array so we can keep track
            addToDefaults(fileName)
        }
    }
    
    internal func get(url:NSURL) -> UIImage? {
        if(cachedVersionExists(url)) {
            let name = cachePrefix + url.absoluteString!.superSanitize()
            let file = FM(l: "Documents", name:name)
            print("Cached Image Location [" + name + "]")
            return UIImage(data: (file.read()!))
        }
        
        return nil;
    }
    
    private func addToDefaults(file:String) {
        print("adding to defaults...")
        let cachedFiles = NSUserDefaults.standardUserDefaults().objectForKey("cachedfiles")!;
        var cached = cachedFiles as! [String];
        cached.append(file)
        NSUserDefaults.standardUserDefaults().setObject(cached, forKey: "cachedfiles");
        NSUserDefaults.standardUserDefaults().synchronize();
    }
}
