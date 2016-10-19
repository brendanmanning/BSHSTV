//
//  VideosTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/11/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
//import SocketIOClientSwift
import PopupDialog
class VideosTableViewController: UITableViewController {
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var videos = [Video]();
    var shouldShowNone = true;
    var popup:PopupDialog!;
    var refreshButtonDefaultColor = UIColor.blackColor();
    var isrefreshing = false;
    
    var videosDownloaded = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
       
        
        refreshButtonDefaultColor = refreshButton.tintColor!;
        
        
        // Get the videos from the server
        self.refreshTableData();
        
        Async.background {
            if NSUserDefaults.standardUserDefaults().boolForKey("showedVideoPopup") == false {
                Async.main {
                    Popup().show("Pause video before leaving this tab", message: "When you leave this tab your video will keep playing. If you like that, GREAT! Otherwise, don't forget to pause it before you leave!", button: "Dismiss", viewController: self as UIViewController)
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "showedVideoPopup")
                }
            }
        }
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        Async.background { self.refreshTableData(); } 
    }
    func updateVideosFromNSUserDefaults()
    {
        Async.main {
            self.refreshButton.enabled = false;
        }
      
        self.refreshButton.tintColor = UIColor.clearColor()
        
        videos.removeAll();
        
        /* Actually download the videos */
        VideoDownloader();
        
        let ids = (NSUserDefaults.standardUserDefaults().objectForKey("videos") as! String).componentsSeparatedByString(",");
        for i in ids
        {
            if(i == "")
            {
                // do nothing
            } else {
                let v = Video();
                v.setVideo(i)
                videos.append(v);
            }
        }
    }
    
    func refreshTableData()
    {
        if(!isrefreshing && isDoneRefreshingVideos()) {
            self.isrefreshing = true;
            Async.background {
                self.updateVideosFromNSUserDefaults()
            }.main {
                if(NSUserDefaults.standardUserDefaults().objectForKey("videos") as! String == "")
                {
                    self.shouldShowNone = true;
                } else {
                    self.shouldShowNone = false;
                }
                self.tableView.reloadData();
                Async.main {
                    //self.refreshButton.enabled = true;
                    self.refreshButton.tintColor = self.refreshButtonDefaultColor;
                    self.isrefreshing = false;
                }
            }
        }
    }
    
    @IBAction override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(shouldShowNone) { return 0 }
        return videos.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! VideoTableViewCell
        // Configure the cell...
        var title = "Loading";
        var subtitletext = "Please be patient";
        var image = UIImage(named: "loading")!;
        Async.main {
                cell.title.text = title
                cell.subtitle.text = subtitletext
                cell.thumbnailImage.image = image;
            }.background {
                if let list = self.tableView.indexPathsForVisibleRows as [NSIndexPath]?
                {
                    if(list.count < indexPath.row) {} else {
                        
                    
                if let t = self.videos[indexPath.row].gettitle() {
                    title = t;
                } else {
                    title = "Sorry, something went wrong :("
                }
                if let st = self.videos[indexPath.row].getdescription() {
                    subtitletext = st;
                } else {
                    subtitletext = "Sorry, something went wrong :("
                }
                
                if let i = self.videos[indexPath.row].getimage() {
                    image = i;
                } else {
                    if let img = UIImage(named: "ImageNotFound") {
                        image = img;
                    } else {
                        image = UIImage();
                    }
                }
                    }
                }

            }.main{
                cell.title.text = title
                cell.subtitle.text = subtitletext
                cell.thumbnailImage.image = image;
        }
        self.videosDownloaded+=1;
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "showStarterVideo");
        NSUserDefaults.standardUserDefaults().setValue(videos[indexPath.item].getid(), forKey: "videoid")
        NSUserDefaults.standardUserDefaults().synchronize();
        self.showDetailViewController(YouTubeVideoViewController(), sender: self);
    }
    
    func isDoneRefreshingVideos() -> Bool {
        if let list = self.tableView.indexPathsForVisibleRows as [NSIndexPath]?
        {
            if(list.count > videosDownloaded) {
                return false;
            } else {
                videosDownloaded = 0;
                return true;
            }
        }
        
        return true;
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
