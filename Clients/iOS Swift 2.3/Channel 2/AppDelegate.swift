//
//  AppDelegate.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/9/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import Foundation
import GoogleMobileAds
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import SwiftyJSON
import LNRSimpleNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {

    var window: UIWindow?
    let notificationManager = LNRNotificationManager();
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        /* VERY IMPORTANT SECTION READ BEFORE ARCHIVING
         * To ensure the app version isn't too old, it will periodically call FeatureChecker() in the background
         * Below we define the identifier for this version as setup on the web interface
         * Typically I use iOS_APP_VX.X
         * If the test for this feature returns false we know the user must update the app
         * Simply by enabling or disabling features on the web interface, we can decide which user MUST update the app */

        /* Right below is where we define the constant */
        NSUserDefaults.standardUserDefaults().setValue("iOS_APP_V2.2", forKey: "version_feature");

        /* Record the time the app launched */
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "app_last_launched")
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("videos") == nil)
        {
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "videos")
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("videoid") == nil)
        {
            NSUserDefaults.standardUserDefaults().setObject("Pn3gp-Ch2kk", forKey: "videoid")
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("announcementaction") == nil)
        {
            NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "announcementaction")
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("announcements") == nil)
        {
            NSUserDefaults.standardUserDefaults().setValue("", forKey: "announcements");
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("notifications") == nil)
        {
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "notifications");
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("phpserver") == nil)
        {
            NSUserDefaults.standardUserDefaults().setValue("{server_url}", forKey: "phpserver");
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("pollid") == nil)
        {
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "pollid")
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("votedin") == nil)
        {
            NSUserDefaults.standardUserDefaults().setObject([String](), forKey: "votedin");
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("shouldRecheckPolls") == nil)
        {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "shouldRecheckPolls");
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("eastereggs") == nil)
        {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "eastereggs");
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("showedVideoPopup") == nil)
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "showedVideoPopup");
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("showStarterVideo") == nil)
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "showStarterVideo")
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("starterVideo") == nil)
        {
            switch(UIDevice.currentDevice().userInterfaceIdiom)
            {
                /* iPads have their own page */
            case .Pad: NSUserDefaults.standardUserDefaults().setValue("{starter_video_pad}", forKey: "starterVideo");
                /* For everything else use the iPhone page */
            default: NSUserDefaults.standardUserDefaults().setValue("{starter_video}", forKey: "starterVideo");
            }
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("YTKEY") == nil)
        {
            NSUserDefaults.standardUserDefaults().setValue("{YT_KEY}", forKey: "YTKEY")
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("API_KEY") == nil)
        {
            NSUserDefaults.standardUserDefaults().setValue("{API_KEY}", forKey: "API_KEY")
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("API_SECRET") == nil)
        {
            NSUserDefaults.standardUserDefaults().setValue("{API_SECRET}", forKey: "API_SECRET");
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("alreadyGoingToArray") == nil)
        {
            NSUserDefaults.standardUserDefaults().setValue([String](), forKey: "alreadyGoingToArray");
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("onThisDayStatus") == nil) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "onThisDayStatus");
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("agreedToPrivacyPolicy") == nil)
        {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "agreedToPrivacyPolicy");
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("hpanimations") == nil)
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hpanimations");
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("cachedfiles") == nil)
        {
            NSUserDefaults.standardUserDefaults().setObject([String](), forKey: "cachedfiles");
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("cachelimit") == nil) {
            NSUserDefaults.standardUserDefaults().setInteger(25, forKey: "cachelimit")
        }

        if(NSUserDefaults.standardUserDefaults().objectForKey("caching") == nil) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "caching")
        }
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "saidNoThisSession");
        
        //NSUserDefaults.standardUserDefaults().setValue("11111111", forKey: "userid")

        UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
        
        // Nav/Tab bar styling
       /* UITabBar.appearance().tintColor = UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0);
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0)]
        window?.tintColor = UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0); */
        
        if(UpgradeManager.sharedInstance.proEnabled()) {
            UpgradeManager.sharedInstance.applyUIChanges();
        } else {
            UpgradeManager.sharedInstance.applyDefaultTheme();
        }
        
        window?.tintColor = UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0);
        
        /*UITabBar.appearance().tintColor = UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0);
        UITabBar.appearance().barTintColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);
        
        
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);
        
        UINavigationBar.appearance().tintColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);*/
       // UINavigationBar.appearance().translucent = false;
        //UINavigationBar.appearance().tintColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);

        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0)]
       
        /* Push Notification Customization */
        notificationManager.notificationsPosition = LNRNotificationPosition.Top
        notificationManager.notificationsBackgroundColor = UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0); // My wonderful custom color
        notificationManager.notificationsTitleTextColor = UIColor.whiteColor(); // Looks better with the green
        notificationManager.notificationsBodyTextColor = UIColor.whiteColor(); // Draw more attention to the title
        notificationManager.notificationsSeperatorColor = UIColor.grayColor();
        
        /* Google Ads Setup */
        GADMobileAds.configureWithApplicationID("{APP_ID}");
        
        /* Google Firebase Setup */
        FIRApp.configure();
        
        /* Firebase Remote Notification Configuration */
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.Alert, .Badge, .Sound]
            //sUNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions(
                //authOptions,
                //completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.currentNotificationCenter().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
            application.registerForRemoteNotifications();
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            //application.registerUserNotificationSettings(settings)
        }

        /* Firebase Debugging */
        if let tok = FIRInstanceID.instanceID().token() {
            print("Token: " + tok);
            saveFcmID();
        } else {
            print("token not set, trying to register");
            Async.background {
                NotificationSettings.sharedInstance.register();
            }
        }
        print("User ID: " + String(NSUserDefaults.standardUserDefaults().valueForKey("userid")));
        
        
        /* Finally we're here! */
        return true;
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("NEW TOKEN VALUE: \(refreshedToken)")
            saveFcmID();
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func applicationReceivedRemoteMessage(remoteMessage: FIRMessagingRemoteMessage) {
        print("got message");
        
        print(remoteMessage.appData)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent: UNNotification, withCompletionHandler: (UNNotificationPresentationOptions) -> Void) {
        print("got 10 push")
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
       
        /* Here is how URLs work:
         * Any data will be passed as a string
         * for example, a user token could be passed in a URL
         * The first two characters should be numbers which indicate
         * which action will be performed. For parity, the last four
         * numbers will be the first two, followed by their sum
 
         * For exmaple: 
         * Token = bShS183sh35
         * URL = bshstv://77bShS183sh357714 */
        
        var applicationUrl = url.absoluteString!;
        
        // Remove the bshstv://
        applicationUrl = applicationUrl[applicationUrl.startIndex.advancedBy(9)..<applicationUrl.endIndex];
        // Isolate the first two numbers
        
        let (valid, action,argument) = validateAndParseURL(applicationUrl);
        print("URL Validity: " + String(valid))
        print("URL Action: " + String(action));
        
        if(valid) {
            switch action {
            case 76:
                NSUserDefaults.standardUserDefaults().setValue(argument, forKey: "account_token");
                NSUserDefaults.standardUserDefaults().synchronize();
                break;
            case 65:
                let controller:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("clubsVC") as! UIViewController
               
                UIApplication.sharedApplication().keyWindow?.rootViewController?.showViewController(controller, sender: UIApplication.sharedApplication().keyWindow?.rootViewController)
                break;
            default:
                break;
            }
        }
        return true;
    }
    
    func validateAndParseURL(url:String) -> (Bool,Int,String) {
        let actionNumeral = url[url.startIndex..<url.startIndex.advancedBy(2)];
        let firstActionNumeral = url[url.startIndex..<url.startIndex.advancedBy(1)];
        let secondActionNumeral = url[url.startIndex.advancedBy(1)..<url.startIndex.advancedBy(2)];
        let parityRepeat = url[url.endIndex.advancedBy(-4)..<url.endIndex.advancedBy(-2)];
        let parityAddition = url[url.endIndex.advancedBy(-2)..<url.endIndex];
        let argument = url[url.startIndex.advancedBy(2)..<url.endIndex.advancedBy(-4)];
        print("========== URL DEBUGGING ==========")
        print("Action Numeral: " + actionNumeral);
        print("First Part of Above: " + firstActionNumeral);
        print("Second Part of Above: " + secondActionNumeral);
        print("Partity Repeat: " + parityRepeat);
        print("Addition of 1st & 2nd: " + parityAddition);
        print("URL Argument: " + argument);
        print("===================================")
        
        if(actionNumeral.isNumeric() && firstActionNumeral.isNumeric() && secondActionNumeral.isNumeric() && parityRepeat.isNumeric() && parityAddition.isNumeric()) {
            if(actionNumeral == parityRepeat) {
                if (Int(firstActionNumeral)! + Int(secondActionNumeral)!) == Int(parityAddition)! {
                    return (true, Int(actionNumeral)!, argument);
                }
            }
        }
        
        return (false, 0, String())
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        /*print(userInfo);
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Since the app's open, iOS won't show a notification for us
        // Use the in-app notification manager
        let json = JSON(userInfo)
        let messageTitle = json["aps"]["alert"]["title"].stringValue;
        let messageBody = json["aps"]["alert"]["body"].stringValue;
      
        if let __url = json["data"]["__url"].string {
            if let type = json["data"]["__type"].string {
                saveURLInfo(type + ":" + __url);
            }
        }
        
        showInAppNotification(messageTitle, message: messageBody);
        */
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject],
                       fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        print(userInfo)
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")

        // Since the app's open, iOS won't show a notification for us
        // Use the in-app notification manager
        let json = JSON(userInfo)
        let messageTitle = json["aps"]["alert"]["title"].stringValue;
        let messageBody = json["aps"]["alert"]["body"].stringValue;
        if let __url = json["data"]["__url"].string {
            if let type = json["data"]["__type"].string {
                saveURLInfo(type + ":" + __url);
            }
        }
        showInAppNotification(messageTitle, message: messageBody);
    }

    func showInAppNotification(title:String, message:String) {
        // Can't present two notifications at once
        dismissInAppPopupIfActive();
        // Show the notification
        notificationManager.showNotification(title, body: message, onTap: {
            // We're not handling this stuff yet
            // Custom actions from popups will come later
        })
    }
    
    func dismissInAppPopupIfActive() {
        if(notificationManager.activeNotification == nil) {
            notificationManager.dismissActiveNotification(nil);
        }
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion(({ (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }));
    }
    
    func saveFcmID() {
        NSUserDefaults.standardUserDefaults().setValue(FIRInstanceID.instanceID().token()!, forKey: "fcmid");
    }
    
    func saveURLInfo(url:String) {
        NSUserDefaults.standardUserDefaults().setValue(url, forKey: "__url");
    }
}
 
