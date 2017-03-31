//
//  NotificationSettings.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/22/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase
import UserNotifications
class NotificationSettings: NSObject {
    class var sharedInstance: NotificationSettings {
        struct Static {
            static var instance:NotificationSettings?;
            static var token:dispatch_once_t = 0;
        }
        
        if Static.instance == nil {
            Static.instance = NotificationSettings();
        }
        
        return Static.instance!;
    }
    
    private var notificationtypes:[UIUserNotificationType]!;
    
    internal func setNotifications(types:[UIUserNotificationType]) {
        self.notificationtypes = types;
    }
    
    internal func notificationsAllowed() -> Bool {
        if(self.notificationtypes != nil) {
            if self.notificationtypes.contains(UIUserNotificationType.Alert) {
                if self.notificationtypes.contains(UIUserNotificationType.Badge) {
                    return true;
                }
            }
        }
        
        return false;
    }
    
    internal func isRegistered() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("registeredForFcm");
    }
    
    /*
    internal func register(completion: ((success:Bool) -> Void)) {
        do {
            try doRegister({ (success) in
                if(success) { self.saveRegistrationStatus(); }
                completion(success: success);
            });
        } catch {
            print("caught error");
            completion(success: false);
        }
    }*/
    
    func saveRegistrationStatus() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "registeredForFcm");
    }
    
     func register() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults();
        var url = "";
        if PreferenceManager.sharedInstance.APIOk() {
            if let firid = FIRInstanceID.instanceID().token() {
                url += defaults.stringForKey("phpserver")!;
                url += "registerForPushes.php?key=" + defaults.stringForKey("API_KEY")!;
                url += "&secret=" + defaults.stringForKey("API_SECRET")!;
                url += "&userid=" + defaults.stringForKey("userid")!;
                url += "&fcmid=" + firid;
                
                if let nsurl = NSURL(string: url) {
                    if let data = NSData(contentsOfURL: nsurl) {
                        let json = JSON(data: data);
                        print("Bool value: " + String(json["success"].boolValue));
                        print("String value: " + json["success"].stringValue)
                        return json["success"].boolValue;
                    }
                }
            }
        }
        
        return false;
     }
    
    internal func requestNotificationsPermissionsFromLocalDevice() {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.Alert, .Badge, .Sound]
            UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions(
                authOptions,
                completionHandler: {_, _ in })
            
            UIApplication.sharedApplication().registerForRemoteNotifications();
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        }

    }
}
