//
//  Popup.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/14/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class Popup: NSObject {
    internal func show(title:String, message:String, button:String,viewController:UIViewController)
    {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        popup.addAction(UIAlertAction(title: button, style: .Default, handler: nil));
        viewController.presentViewController(popup, animated: true, completion: nil)
    }
    
    internal func system(title:String, message:String, button:String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: button, style: .Default, handler: nil));
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    internal func confirm(why:String, viewController:UIViewController, completion: (confirmed:Bool) -> Void) {
        
        var style = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? UIAlertControllerStyle.Alert : UIAlertControllerStyle.ActionSheet;
        
        let alert = UIAlertController(title: "Are you sure?", message: why, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            completion(confirmed: false);
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            completion(confirmed: true);
        }));
        
        alert.popoverPresentationController?.sourceView = viewController.view
        alert.popoverPresentationController?.sourceRect = viewController.view.bounds
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    internal func confirm(why:String, viewController:UIViewController, preferred:Int?, desctructive:[Int]?, yesOption:String, noOption:String, completion: (confirmed:Bool) -> Void) {
        
        var yesStyle = UIAlertActionStyle.Default;
        var noStyle = UIAlertActionStyle.Default;
        
        var style = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? UIAlertControllerStyle.Alert : UIAlertControllerStyle.ActionSheet;
        
        if let desctructiveOptions = desctructive {
            noStyle = (desctructiveOptions.contains(0)) ? UIAlertActionStyle.Destructive : UIAlertActionStyle.Default;
            yesStyle = (desctructiveOptions.contains(1)) ? UIAlertActionStyle.Destructive : UIAlertActionStyle.Default;
        }
        
        let alert = UIAlertController(title: "Are you sure?", message: why, preferredStyle: style)
        
        let cancel = UIAlertAction(title: noOption, style: noStyle, handler: { (_) -> Void in
            completion(confirmed: false);
        })
        
        let yes = UIAlertAction(title: yesOption, style: yesStyle, handler: { (_) -> Void in
            completion(confirmed: true);
        })
        
        alert.addAction(yes)
        alert.addAction(cancel);
        
        if(preferred == 0) {
            alert.preferredAction = cancel;
        } else if(preferred == 1) {
            alert.preferredAction = yes;
        }
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*internal func yn(title:String, message:String, yesButton:String, noButton:String, viewController:UIViewController) -> Bool
    {
        let popup = PopupDialog(title: title, message: message);
        let yes = PopupDialogButton(title: yesButton, action: { return true; });
        let no = PopupDialogButton(title: noButton, action: { return false; });
        popup.addButtons([yes, no]);
        viewController.presentViewController(popup, animated: true, completion: {})
    }*/
}
