//
//  LineByLineDownloader.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/17/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

/* The socket server emits the On This Day events line by line, so tracking the progress of the download is easier */
/* This class managers the storing and writing part of that process, it does not parse the output however */

import UIKit

class LineByLineDownloader: NSObject {
    var totalLines = -1;
    var linesDownloaded = -1;
    var fileAsString:String!;
    
    var path:String!;
    
    let NL = "\n";
    
    init(total_lines:Int, fileToSaveAs:String)
    {
        self.totalLines = total_lines;
        self.path = fileToSaveAs;
        self.linesDownloaded = 0;
    }
    
    internal func newline(contents:String)
    {
        if(linesDownloaded > 0)
        {
            self.fileAsString = self.fileAsString + self.NL + contents;
            self.linesDownloaded += 1;
        }
    }
    
    internal func flushToDisk() -> Bool
    {
        let filemanager = FM(l: "Documents", name: "OnThisDay.txt")
        return (filemanager.write(fileAsString))
    }
    
    internal func isReadyToFlush() -> Bool {
        if(totalLines == -1) { return false }
        if(totalLines == linesDownloaded)
        {
            return true
        }
            return false
    }
}
