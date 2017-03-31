//
//  InitialSetup.swift
//  Channel 2
//
//  Created by Brendan Manning on 10/18/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON
/*class InitialSetup: NSObject {
    init(vc:UIViewController, message:String, subMessage:String, wait:Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey("userid") == nil {
            /* Prepare an alert to show the user while we're perfoming setup */
            
            let alert = UIAlertController(title: message, message: subMessage, preferredStyle: .Alert)
            if(wait){
                alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil));
            } else {
            vc.presentViewController(alert, animated: true, completion: nil)
            }
    
            if let baseUrl = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") {
                if let key = NSUserDefaults.standardUserDefaults().valueForKey("API_KEY") {
                    if let secret = NSUserDefaults.standardUserDefaults().valueForKey("API_SECRET") {
                        if let url = NSURL(string: (baseUrl as! String) as String + "generateUserID.php?key=" + (key as! String) as! String + "&secret=" + (secret as! String) as! String) {
                            print(url.absoluteString)
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
}*/

class NameSetup:NSObject {
    internal func askForName(vc:UIViewController, callback: (success:Bool) -> Void) {
        var setName = false;
        let alertController = UIAlertController(title: "What's your name", message: "(Required to join clubs)", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Your name here"
        })
    
    
        let action = UIAlertAction(title: "Save Name", style: .Default, handler: {[weak self](paramAction:UIAlertAction!) in
            if let textFields = alertController.textFields{
                let theTextFields = textFields as [UITextField]
                let enteredText = theTextFields[0].text!
                
                if(enteredText.isAlphaNumeric()) {
                    NSUserDefaults.standardUserDefaults().setValue(enteredText, forKey: "user_name");
                    Popup().banner("Name Set!", message: "Reclick that club to join it!", onClick: nil)
                    callback(success: true)
                } else {
                    Popup().system("Input invalid", message: "Only alphanumeric names are allowed (a-z A-Z 0-9)", button: "Dismiss", viewController: vc)
                }
            }
            });
        
        let noAction = UIAlertAction(title: "I'd rather not", style: .Default, handler: {(_) -> Void in
            callback(success: false);
        });
        
        alertController.addActions([noAction,action]);
        alertController.preferredAction = action;
        
        vc.presentViewController(alertController, animated: true, completion: nil);

    }
}
class IDSetup:NSObject {
    private var url:NSURL!;
    override init() {
        if let baseUrl = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") {
            print("a")
            if let key = NSUserDefaults.standardUserDefaults().valueForKey("API_KEY") {
                print("b")
                if let secret = NSUserDefaults.standardUserDefaults().valueForKey("API_SECRET") {
                    print("c")
                    if let baseUrlString = baseUrl as? String {
                        print("d")
                        if let keyString = key as? String {
                            print("e")
                            if let secretString = secret as? String {
                                print("f")
                                let urlStr = baseUrlString + "generateUserID.php?key=" + keyString + "&secret=" + secretString;
                                print(urlStr)
                                if let API_URL = NSURL(string: urlStr) {
                                    url = API_URL;
                                    print("g")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func isSetup() -> Bool {
        return (NSUserDefaults.standardUserDefaults().objectForKey("userid") != nil);
    }
    
    func getUserID() -> String? {
        if let idObject = NSUserDefaults.standardUserDefaults().valueForKey("userid") {
            if let id = idObject as? String {
                return id;
            }
        }
        
        return nil;
    }
    
    func generateUserID() -> Bool {
        if let data = NSData(contentsOfURL: self.url) {
            let json = JSON(data: data)
            if(json["status"] == "ok") {
                NSUserDefaults.standardUserDefaults().setValue(json["id"].stringValue, forKey: "userid")
                NSUserDefaults.standardUserDefaults().synchronize();
                return true;
            }
        }
        
        return false;
    }
}
