//
//  Popup.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/14/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import PopupDialog;

class Popup: NSObject {
    internal func show(title:String, message:String, button:String,viewController:UIViewController)
    {
        let popup = PopupDialog(title: title, message: message);
        popup.addButton(PopupDialogButton(title: button, action: nil));
        viewController.presentViewController(popup, animated: true, completion: nil)
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
