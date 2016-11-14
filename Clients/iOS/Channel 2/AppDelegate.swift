//
//  AppDelegate.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/9/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import PopupDialog
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        /* VERY IMPORTANT SECTION READ BEFORE ARCHIVING
         * To ensure the app version isn't too old, it will periodically call FeatureChecker() in the background
         * Below we define the identifier for this version as setup on the web interface
         * Typically I use iOS_APP_VX.X
         * If the test for this feature returns false we know the user must update the app
         * Simply by enabling or disabling features on the web interface, we can decide which user MUST update the app */

        /* Right below is where we define the constant */
        NSUserDefaults.standardUserDefaults().setValue("iOS_APP_V2.1", forKey: "version_feature");

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
            case .Pad: NSUserDefaults.standardUserDefaults().setValue("http://bshstv.brendanmanning.com/p/defaultVideo-iPad.html", forKey: "starterVideo");
                /* For everything else use the iPhone page */
            default: NSUserDefaults.standardUserDefaults().setValue("http://bshstv.brendanmanning.com/p/defaultVideo-iPhone.html", forKey: "starterVideo");
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

        /*
        // Popup customization
        let pv = PopupDialogDefaultView.appearance()
        pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
        pv.titleColor   = UIColor.whiteColor()
        pv.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
        pv.messageColor = UIColor(white: 0.8, alpha: 1)

        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = UIColor(red:0.11, green:0.43, blue:0.05, alpha:1.0)
        pcv.cornerRadius    = 2
        pcv.shadowEnabled   = true
        pcv.shadowColor     = UIColor.blackColor()

        // Overlay
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled = true
        ov.blurRadius  = 30
        ov.liveBlur    = true
        ov.opacity     = 0.5
        ov.color       = UIColor.blackColor()

        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
        db.titleColor     = UIColor.whiteColor()
        db.buttonColor    = UIColor(red:0.14, green:0.55, blue:0.06, alpha:1.0)
        db.separatorColor = UIColor(red:0.44, green:0.49, blue:0.44, alpha:1.0)
        */

        /*
         *** Google Ads Setup ***
         */

        GADMobileAds.configureWithApplicationID("{admob_app_id}");



        return true;
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
        UIApplication.sharedApplication().applicationIconBadgeNumber -= 1;
    }
}
