//
//  CacheManager.swift
//  Channel 2
//
//  Created by Brendan Manning on 12/9/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import Foundation

class CacheManager: NSObject {
    class var sharedInstance: CacheManager {
        struct Static {
            static var instance:CacheManager?;
            static var token:dispatch_once_t = 0;
        }
        
        if Static.instance == nil {
            Static.instance = CacheManager();
        }
        
        return Static.instance!;
    }
    
    internal func clear(callback: (itemsDeleted:Int) -> Void) {
        // Get the list of files from NSUserDefaults
        let cachedFiles = NSUserDefaults.standardUserDefaults().objectForKey("cachedfiles")!;
        let cache = cachedFiles as! [String];
        
        // Delete each one of them
        for cachedFile in cache {
            let file = FM(l: "Documents", name: cachedFile);
            file.delete();
        }
        
        // Reset our tracker of all cached files (NSUserDefs) 
        NSUserDefaults.standardUserDefaults().setObject([String](), forKey: "cachedfiles");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        // Call the callback
        callback(itemsDeleted: cache.count)
    }
    
    internal func cacheSize() -> Int {
        // Get the list of files from NSUserDefaults
        let cachedFiles = NSUserDefaults.standardUserDefaults().objectForKey("cachedfiles")!;
        let cache = cachedFiles as! [String];
        
        for c in cache {
            print("File: " + c);
        }
        
        // Return its size
        return cache.count;
    }
    
    internal func cachingEnabled() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("caching");
    }
}
