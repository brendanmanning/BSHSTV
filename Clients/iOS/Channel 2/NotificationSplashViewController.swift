//
//  NotificationSplashViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/23/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Async
class NotificationSplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    @IBAction func performSetup(sender: AnyObject) {
        Async.background {
                let worked = NotificationSettings.sharedInstance.register();
                NSUserDefaults.standardUserDefaults().setBool(worked, forKey: "registeredForFcm")
                NSUserDefaults.standardUserDefaults().synchronize();
        }
        Async.main {
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
            }.main {
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    @IBAction func setupDenied(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
