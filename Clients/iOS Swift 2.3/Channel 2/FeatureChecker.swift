//
//  FeatureChecker.swift
//  Channel 2
//
//  Created by Brendan Manning on 10/15/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import Foundation
import SwiftyJSON

class FeatureChecker: NSObject {
    private var url = String(NSUserDefaults.standardUserDefaults().valueForKey("phpserver")!) + "isfeatureenabled.php?key={api_key}&secret={api_secret}&name={feature_name}";
    internal var message = "";
    internal var statusCode = -1;
    private var defaultValue = true;
    internal func check(feature:String) -> Bool {
        url = url.stringByReplacingOccurrencesOfString("{api_key}", withString: String(NSUserDefaults.standardUserDefaults().valueForKey("API_KEY")!))
        url = url.stringByReplacingOccurrencesOfString("{api_secret}", withString: String(NSUserDefaults.standardUserDefaults().valueForKey("API_SECRET")!));
        url = url.stringByReplacingOccurrencesOfString("{feature_name}", withString: feature);
        print(url);
        if let u = NSURL(string: url) {
            if let contents = NSData(contentsOfURL: u) {
                let json = JSON(data: contents)
                statusCode = json["status"].intValue;
                message = json["message"].stringValue;
                return json["enabled"].boolValue;
            }
        }
        
        /* Return default value */
        return defaultValue;
    }
    
    internal func assumeFalse() {
        self.defaultValue = false;
    }
}
