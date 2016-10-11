//
//  PollsTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/19/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class PollsTableViewController: UITableViewController {

    var polls = [OnlinePoll]();
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var shouldShowNone = true;
    var refreshButtonDefaultTint:UIColor!;
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshButtonDefaultTint = refreshButton.tintColor;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        refreshButton.enabled = false;
        refreshButton.tintColor = UIColor.clearColor()
        loadData();
        
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        refreshButton.enabled = false;
        refreshButton.tintColor = UIColor.clearColor()
        loadData()
    }
    override func viewDidAppear(animated: Bool) {
        if(NSUserDefaults.standardUserDefaults().boolForKey("shouldRecheckPolls"))
        {
            self.tableView.reloadData();
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "shouldRecheckPolls")
        }
    }
    
    func loadData()
    {
        Async.background {
            do {
                self.polls = try PollsDownloader().get();
                Async.main {
                    self.shouldShowNone = false;
                }
            } catch {
                Popup().show("An error occured", message: "We couldn't get the polls from the server. Please check your connection and try again", button: "Okay", viewController: self as UIViewController)
                Async.main {
                    self.shouldShowNone = true;
                }
            }
            }.main {
                self.tableView.reloadData();
                self.refreshButton.enabled = true;
                self.refreshButton.tintColor = self.refreshButtonDefaultTint;
        }
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
        if(shouldShowNone) { return 0; }
        return polls.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pollCell", forIndexPath: indexPath) as! PollTableViewCell;
        let voter = OnlineVoter(poll: (polls[indexPath.row].id));
        if(voter.didAlreadyVotedInPoll())
        {
            cell.completionBadge.backgroundColor = UIColor.greenColor();
            cell.completionBadge.text = "DONE"
        }
        // I know they're flipped, but I don't care
        // I didn't like how it looked with the description in bold...,
        // so sue me....actually don't
        
        cell.promptLabel.text = polls[indexPath.row].prompt;
        cell.titleLabel.text = polls[indexPath.row].desc;

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSUserDefaults.standardUserDefaults().setInteger(Int(polls[indexPath.row].id)!, forKey: "pollid");
        NSUserDefaults.standardUserDefaults().synchronize();
        self.performSegueWithIdentifier("showPollDetail", sender: self)
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
