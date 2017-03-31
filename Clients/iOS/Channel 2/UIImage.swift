//
//  UIImage.swift
//  Treasure
//
//  Created by Brendan Manning on 1/2/17.
//  Copyright © 2017 BrendanManning. All rights reserved.
//

import UIKit
import Firebase
extension UIImage {
    class func with(url:String, callback: ((image: UIImage?) -> Void)) {
        if let fileurl = NSURL(string: url) {
            if let data = NSData(contentsOfURL: fileurl) {
                if let image = UIImage(data: data) {
                    callback(image: image);
                    return;
                } else {
                    callback(image: nil);
                }
            } else {
                callback(image: nil);
            }
        } else {
            callback(image: nil);
        }
    }
}
