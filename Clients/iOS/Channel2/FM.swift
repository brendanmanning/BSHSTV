//
//  FM.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/17/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//


/* FM stands for FileManager. So before you ask, it's got nothing to do with the FM frequency on the radio */


import Foundation
class FM: NSObject {
    enum Location {
        case Documents
        case Bundle
    }
    
    private var fileLocationType:Location;
    private var filename = "";
    private var filepath = "";
    init(l:String, name:String)
    {
        self.fileLocationType = .Documents
        self.filename = name;
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)
        if paths.count > 0
        {
            if let dirpath = paths[0] as? NSString
            {
                filepath = dirpath.stringByAppendingPathComponent(self.filename)
            }
        }
    }
    
    internal func lines() -> [String]
    {
        do {
            let contentsOfFile = try String(contentsOfFile: filepath)
            return contentsOfFile.componentsSeparatedByString("<br>")
        } catch {
            return [];
        }
    }
    
    internal func exists() -> Bool
    {
        if(self.fileLocationType == .Documents)
        {
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask, true)
            if paths.count > 0
            {
                let dirpath = paths[0] as NSString
                let filepath = dirpath.stringByAppendingPathComponent(self.filename)
                return (NSFileManager.defaultManager().fileExistsAtPath(filepath))
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
    
    internal func write(string:String) -> Bool {
        if(self.filename == "") { return false }
        do {
            try string.writeToFile(self.filepath, atomically: true, encoding: NSUTF8StringEncoding)
            return true;
        } catch {
            return false;
        }
    }
}
