//
//  Extensions.swift
//  Channel 2
//
//  Created by Brendan Manning on 10/12/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

/* Easy screenshotting of current window */
public extension UIWindow
{
    func screenshot() -> UIImage {
       
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, UIScreen.mainScreen().scale)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

public extension UIView
{
    func blur() {
        /* Define our blur */
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Dark);
        
        /* Define our BlurView */
        var blurView = UIVisualEffectView(effect: blur);
        blurView.frame = self.bounds;
        
        self.addSubview(blurView);
    }

}
public extension UIAlertController
{
    func addActions(actions: [UIAlertAction]) {
        for action in actions {
            self.addAction(action)
        }
    }
}