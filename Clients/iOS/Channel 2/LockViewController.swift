//
//  LockViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 10/12/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class LockViewController: NSObject {
    private var vc:UIViewController!;
    private var options:[LockViewControllerOption]!;
    private var title:String!;
    private var message:String!;
    init(viewController:UIViewController, selections:[LockViewControllerOption], lockedTitle:String, lockedMessage:String)
    {
        self.vc = viewController;
        self.options = selections;
        self.title = lockedTitle;
        self.message = lockedMessage;
    }
    
    internal func present()
    {
        /* Blur the view controller an d hide all nav bars */
       // self.vc.navigationController?.navigationBarHidden = true;
        //self.vc.tabBarController?.tabBar.hidden = true;
        //self.vc.view.blur();
        
        /* Create a popup dialog */
        let dialog = UIAlertController(title: self.title, message: self.message, preferredStyle: .Alert)
        for option in options {
            dialog.addAction(UIAlertAction(title: option.title, style: .Default, handler: { (UIAlertAction) in
                option.choose();
            }));
        }
        if vc.presentingViewController != nil { vc.dismissViewControllerAnimated(false, completion: nil) }
        self.vc.presentViewController(dialog, animated: true, completion: nil)
    }
}
class LockViewControllerOption: NSObject {
    private var title:String!;
    private var urlString:String!;
    
    init(optionTitle:String,optionUrl:String?)
    {
        self.title = optionTitle;
        self.urlString = optionUrl;
    }
    
    internal func choose()
    {
        if self.urlString == nil { return }
        if let u = self.urlString {
            if let url = NSURL(string: u) {
                if UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url);
                }
            }
        }
    }
}
