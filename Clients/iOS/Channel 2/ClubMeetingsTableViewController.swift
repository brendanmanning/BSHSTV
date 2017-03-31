//
//  ClubMeetingsTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/26/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import SwiftyJSON
class ClubMeetingsTableViewController: UITableViewController {
    private var fetchedData = false;
    private var activityView:UIActivityIndicatorView!;
    internal var club = -1;
    private var meetings = [Meeting]();
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.tableView.backgroundColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) : UIColor.whiteColor();
        
        //addActivityView();
        
        if PreferenceManager.sharedInstance.APIOk() {
            Async.background {
            var urlString = NSUserDefaults.standardUserDefaults().stringForKey("phpserver")! + "clubannouncements.php?niceformatting&meetingformatting&club=" + String(self.club) ;
            urlString += "&userid=" + NSUserDefaults.standardUserDefaults().stringForKey("userid")!;
            print(urlString)
            if let url = NSURL(string: urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!) {
                do {
                let dataStr = try String(contentsOfURL: url)
                    print(dataStr)
                    let data = (dataStr as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    let json = JSON(data: data!);
                    for(key,subJson) in json[] {
                        let meeting = Meeting();
                        meeting.title = subJson["title"].stringValue;
                        meeting.date = subJson["date"].stringValue;
                        self.meetings.append(meeting);
                        print(subJson["title"].stringValue);
                    }
                    print("data fetched")
                    Async.main {
                        self.tableView.reloadData();
                        self.removeActivityView();
                    }
                } catch {
                    print("error getting string")
                }
            } else {
                print("no cast")
            }
            }
        } else {
            print("api not okay")
        }
    }
    
    private func addActivityView() {
        let spinnerSize:CGFloat = 60;
        //activityView = UIActivityIndicatorView(frame: CGRect(x: ((tableView.backgroundView?.window?.frame.width)! / 2), y: ((tableView.backgroundView?.window?.frame.height)! / 2), width: spinnerSize, height: spinnerSize));
        //activityView.startAnimating();
        //tableView.backgroundView?.addSubview(activityView);
    }
    
    private func removeActivityView() {
        //activityView.hidesWhenStopped = true;
        //activityView.stopAnimating();
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cell");
        let cell = tableView.dequeueReusableCellWithIdentifier("meetingCell")! as! MeetingTableViewCell;
        cell.title!.text = meetings[indexPath.row].title;
        cell.subtitle!.text = meetings[indexPath.row].date;
        
        cell.backgroundColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) : UIColor.whiteColor();
        cell.title.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.whiteColor() : UIColor.blackColor();
        cell.subtitle.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.whiteColor() : UIColor.blackColor();
        
        return cell;
    }
}
class Meeting:NSObject {
    internal var title:String!;
    internal var date:String!;
}
