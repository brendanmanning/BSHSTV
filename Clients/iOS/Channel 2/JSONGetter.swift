//
//  JSONGetter.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/2/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONGetter: NSObject {
    private var URL:String!;
    
    init(url:String) {
        self.URL = url;
    }
    
    internal func bindParam(param:String, value:String) {
        if let url = self.URL {
            self.URL = url.stringByReplacingOccurrencesOfString(param, withString: value);
        }
    }
    
    internal func addSuffix(suffix:String) {
        if let url = self.URL {
            self.URL = url + suffix;
        }
    }
    
    internal func removeSuffix(suffix:String) {
        if let url = self.URL {
            self.URL = url.stringByReplacingOccurrencesOfString(suffix, withString: "")
        }
    }
    
    internal func json() throws -> JSON? {
        if let asString = self.URL {
            let encodedURL = asString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            print(encodedURL)
            if let url = NSURL(string: encodedURL) {
                if UIApplication.sharedApplication().canOpenURL(url) {
                    if let data = NSData(contentsOfURL: url) {
                        return JSON(data: data)
                    } else {
                        throw JSONError.Failed;
                    }
                } else {
                    throw JSONError.URLNotValid;
                }
            } else {
                throw JSONError.URLNotValid;
            }
        } else {
            throw JSONError.URLNotSet;
        }
        
        return nil;
    }
}
enum JSONError:ErrorType {
    case Failed;
    case URLNotSet;
    case URLNotValid;
}