//
//  PerferenceManager.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/22/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import Foundation

class PreferenceManager: NSObject {
    class var sharedInstance: PreferenceManager {
        struct Static {
            static var instance:PreferenceManager?;
            static var token:dispatch_once_t = 0;
        }
        
        if Static.instance == nil {
            Static.instance = PreferenceManager();
        }
        
        return Static.instance!;
    }
    
    internal func APIOk() -> Bool {
        if(exists("phpserver")) {
            if(exists("API_KEY")) {
                if(exists("API_SECRET")) {
                    if(exists("userid")) {
                        return true;
                    }
                }
            }
        }
        
        return false;
    }

    private func setting(name:String, handler:(AnyObject?, exists:Bool) -> Void) {
        if let setting = (NSUserDefaults.standardUserDefaults().objectForKey(name)) {
            handler(setting, exists: true);
        } else {
            handler(nil, exists: false);
        }
    }
    
    internal func string(name:String, handler:(value:String?, exists:Bool) -> Void) {
        setting(name, handler: {(object:AnyObject?, exists:Bool) -> Void in
            if exists {
                if let string = object as? String {
                    handler(value: string, exists: exists);
                }
            } else {
                handler(value: nil, exists: exists);
            }
        });
    }
    
    internal func integer(name:String, hander:(value:Int?, exists:Bool) -> Void) {
        
    }
    
    internal func exists(name:String) -> Bool {
        return (NSUserDefaults.standardUserDefaults().objectForKey(name) != nil);
    }
}
