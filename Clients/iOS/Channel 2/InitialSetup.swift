//
//  InitialSetup.swift
//  Channel 2
//
//  Created by Brendan Manning on 10/18/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON
class InitialSetup: NSObject {
    init(vc:UIViewController, message:String, subMessage:String, wait:Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey("userid") == nil {
            /* Prepare an alert to show the user while we're perfoming setup */
            let alert = UIAlertController(title: message, message: subMessage, preferredStyle: .Alert)
            if(wait){
                alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil));
            }
            vc.presentViewController(alert, animated: true, completion: nil)
    
            if let baseUrl = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") as? String {
                if let key = NSUserDefaults.standardUserDefaults().valueForKey("API_KEY") as? String {
                    if let secret = NSUserDefaults.standardUserDefaults().valueForKey("API_SECRET") as? String {
                        if let url = NSURL(string: baseUrl + "generateUserID.php?key=" + key + "&secret=" + secret) {
                            if let data = NSData(contentsOfURL: url) {
                                let json = JSON(data: data);
                                NSUserDefaults.standardUserDefaults().setValue(json["id"].stringValue, forKey: "userid")
                                NSUserDefaults.standardUserDefaults().synchronize();
    }
    }
    }
    }
    }
            if(!wait) {
                vc.dismissViewControllerAnimated(true, completion: nil)
            }
    }
    }
}
