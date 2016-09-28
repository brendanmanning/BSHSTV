//
//  Video.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/11/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON

class Video: NSObject {
    // Youtube API Constants
    private let API_URL = "https://www.googleapis.com/youtube/v3/videos?part=snippet&id={video_id}&key=";
    private let API_KEY = "AIzaSyBvYcQtI1J5zsGMdeHFhAWiWjyH2NllRv8";
    
    // JSON constants
    private var json:JSON = nil;
    private var id:String!;
    
    // Error handling
    private var error = false;
    
    internal func setVideo(videoID:String) {
        id = videoID;
    }
    
    internal func gettitle() -> String?
    {
        checkJSON();
        if(self.error)
        {
            return "No Internet"
        }
        return json["items"][0]["snippet"]["title"].stringValue;
        
    }
    
    internal func getdescription() -> String?
    {
        checkJSON();
        if(self.error)
        {
            return "Please check your connection"
        }
        return json["items"][0]["snippet"]["description"].stringValue;
    }
    
    internal func getimage() -> UIImage?
    {
        checkJSON();
        if(self.error) { return UIImage(named: "nowifi")!; }
        let imageURL = json["items"][0]["snippet"]["thumbnails"]["default"]["url"].stringValue
        if let url = NSURL(string: imageURL) {
            if let data = NSData(contentsOfURL: url) {
                if let img = UIImage(data: data)
                {
                    return img
                } else {
                    return UIImage(named: "ImageNotFound")!;
                }
            }
        }
        return UIImage(named: "ImageNotFound")!;
    }

    internal func getid() -> String?
    {
        return self.id;
    }
    
    private func getYouTubeRequestData(videoID:String) -> NSData
    {
        var jsonData:NSData!;
        jsonData = NSData(contentsOfURL: NSURL(string: requestURL(videoID))!);
        if let url = NSURL(string: requestURL(videoID))
        {
            if let data = NSData(contentsOfURL: url)
            {
                return data;
            }
        }
        
        // Error JSON
        let path = NSBundle.mainBundle().pathForResource("Error", ofType: "json")
        self.error = true;
        return NSData(contentsOfFile: path!)!
    }
    
    private func checkJSON() {
        if(json == nil) {
            let dataFromNetworking = getYouTubeRequestData(self.id)
            json = JSON(data: dataFromNetworking)
        }
    }
    
    private func requestURL(videoID:String) -> String {
        return API_URL.stringByReplacingOccurrencesOfString("{video_id}", withString: videoID) + API_KEY;
    }
}
