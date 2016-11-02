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

class NameSetup:NSObject {
    internal func askForName(vc:UIViewController) -> Bool {
        var setName = false;
        let alertController = UIAlertController(title: "What's your name", message: "* This information is used in accordance with the Privacy Policy you agreed to when you first opened this app *", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = "Your name here"
        })
    
    
        let action = UIAlertAction(title: "Save Name", style: .Default, handler: {[weak self](paramAction:UIAlertAction!) in
            if let textFields = alertController.textFields{
                let theTextFields = textFields as [UITextField]
                let enteredText = theTextFields[0].text
                
                NSUserDefaults.standardUserDefaults().setValue(enteredText, forKey: "user_name");
                setName = true;
            }
            });
        
        let noAction = UIAlertAction(title: "I'd rather not", style: .Default, handler: nil);
        
        alertController.addActions([noAction,action]);
        alertController.preferredAction = action;
        
        vc.presentViewController(alertController, animated: true, completion: nil)
        
        return setName;
    }
}
