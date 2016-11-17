//
//  UpgradeManager.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/12/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class UpgradeManager:NSObject {
    let defaults = NSUserDefaults.standardUserDefaults();
    private var enabled = false;
    var ad:InterstitialManager!;
    class var sharedInstance: UpgradeManager {
        struct Static {
            static var instance:UpgradeManager?;
            static var token:dispatch_once_t = 0;
        }
        
        if Static.instance == nil {
            Static.instance = UpgradeManager();
        }
       
        return Static.instance!;
    }

    internal func upgrade(viewController: UIViewController) {
        if(ad.presentIfReady(viewController)) {
            defaults.setObject(NSDate(), forKey: "upgradeEarned");
            print("[upgrade earned]")
            
            applyUIChanges();
            
        } else {
            print("[ad was not ready]");
        }
    }
    
    internal func applyUIChanges() {
        /* Apply changes from App Delegate */
        UITabBar.appearance().tintColor = UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0);
        UITabBar.appearance().barTintColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);
        
        
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);
        
        UINavigationBar.appearance().tintColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    internal func applyDefaultTheme() {
        /* This too was originaly in AppDelegate */
        UITabBar.appearance().tintColor = UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0);
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0)]
    }
    
    internal func ready() -> Bool {
        return ad.ready();
    }
    
    override init() {
        super.init();
        
        self.enabled = self.proEnabled();
        ad = InterstitialManager();
    }
    
    internal func proEnabled() -> Bool {
        if let earned = defaults.objectForKey("upgradeEarned") {
            // Upgrade lasts for 12 hours
            return (NSUserDefaults.standardUserDefaults().objectForKey("app_last_launched") as! NSDate).timeIntervalSinceDate(earned as! NSDate) < 43200
        }

        return false;
    }
    
}
