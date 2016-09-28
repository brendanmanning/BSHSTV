//
//  VotingViewControllerTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/20/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class VotingViewControllerTableViewController: UITableViewController {

    @IBOutlet weak var pleaseVoteLabel: UILabel!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var choiceSelector: UISegmentedControl!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    /* Progress Bars */
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var p1: UIProgressView!
    
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var p2: UIProgressView!
    
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var p3: UIProgressView!
    
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var p4: UIProgressView!
    
    var poll:OnlinePoll!;
    var isOkayToShow = false;
    var voter:OnlineVoter!;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Get information from the server
        
        titleLabel.text = "Title: Loading..."
        voteButton.enabled = false;
        self.choiceSelector.selectedSegmentIndex = 0; // Just in case
        Async.background {
            self.voter = OnlineVoter(poll:String(NSUserDefaults.standardUserDefaults().integerForKey("pollid")));
        }.main {
                if(self.voter.didAlreadyVotedInPoll())
                {
                    self.choiceSelector.hidden = true;
                    self.voteButton.setTitle("Thanks for voting", forState: .Normal)
                
                } else {
                    self.voteButton.setTitle("Press here to submit your vote", forState: .Normal)
                    self.voteButton.enabled = true;
                }
        }
        
        getPollInfo();
        
        
        // Hide progress bars on iphone bc they are too small
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            p1.hidden = true;
            p2.hidden = true;
            p3.hidden = true;
            p4.hidden = true;
        }
        
    }

    func getPollInfo()
    {
        Async.background {
            do {
                self.poll =  try PollDownloader().get(NSUserDefaults.standardUserDefaults().integerForKey("pollid"));
                self.isOkayToShow = true;
                Async.main {
                    self.updateUserInterface()
                }
            } catch {
                Async.main {
                    Popup().show("Oops. Something went wrong😢", message: "We couldn't get the needed information from the server. Please try again later",button: "Dismiss",viewController: self as UIViewController);
                }
            }
        }
    }
    
    @IBAction func doSubmitVote(sender: AnyObject) {

        if voter == nil { return; }
        print(String(NSUserDefaults.standardUserDefaults().integerForKey("pollid")));
        if(!voter.didAlreadyVotedInPoll())
        {
            if(voter.vote((choiceSelector.selectedSegmentIndex + 1)))
            {
                print("Selected segment index: " + String(choiceSelector.selectedSegmentIndex))
                voter.remember();
                voteButton.setTitle("Vote Submitted. Thank you!", forState: .Normal)
                UIView.animateWithDuration(2.0, animations: {
                    self.choiceSelector.alpha = 0;
                    }, completion: { _ in
                        self.choiceSelector.hidden = true;
                })
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "shouldRecheckPolls")
                getPollInfo();
            } else {
                Popup().show("Vote not submitted", message: "Please try again later", button: "Dismiss", viewController: self as UIViewController)
            }
        }
        
        self.tableView.reloadData();
        
    }
    func updateUserInterface()
    {
        if(!voter.didAlreadyVotedInPoll()) {
            titleLabel.text = "Title: " + poll.prompt;
        } else {
            titleLabel.text = "The question was: " + poll.prompt;
        }
        
        l1.text = poll.choice(1) + " (" + votesToVoteString(String(Int(poll.getPercents()[0] * Float(poll.totalvotes))) + " votes)");
        l2.text = poll.choice(2) + " (" + votesToVoteString(String(Int(poll.getPercents()[1] * Float(poll.totalvotes))) + " votes)");
        l3.text = poll.choice(3) + " (" + votesToVoteString(String(Int(poll.getPercents()[2] * Float(poll.totalvotes))) + " votes)");
        l4.text = poll.choice(4) + " (" + votesToVoteString(String(Int(poll.getPercents()[3] * Float(poll.totalvotes))) + " votes)");
        
        choiceSelector.removeAllSegments();
        choiceSelector.insertSegmentWithTitle(poll.choice(1), atIndex: 0, animated: true)
        choiceSelector.insertSegmentWithTitle(poll.choice(2), atIndex: 1, animated: true)
        choiceSelector.insertSegmentWithTitle(poll.choice(3), atIndex: 2, animated: true)
        choiceSelector.insertSegmentWithTitle(poll.choice(4), atIndex: 3, animated: true)
        choiceSelector.selectedSegmentIndex = 0;
        
        /*p1.progress = 0;
        p2.progress = 0;
        p3.progress = 0;
        p4.progress = 0;*/
        p1.progress = Float(poll.getPercents()[0])
        p2.progress = Float(poll.getPercents()[1])
        p3.progress = Float(poll.getPercents()[2])
        p4.progress = Float(poll.getPercents()[3])
        
       // print("1 == " + String(percentForOption(1, inPoll: poll)))
        //print("2 == " + String(percentForOption(2, inPoll: poll)))
    }

    func votesToVoteString(v:String) -> String
    {
        if(v == "1 votes)") { return "1 vote)" } else { return v; }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    
        //BUG FIX
        if(voter == nil)
        {
            voter = OnlineVoter(poll: String(NSUserDefaults.standardUserDefaults().valueForKey("pollid")!))
        }
    
        if(voter.didAlreadyVotedInPoll())
        {
            pleaseVoteLabel.text = "You already voted in this poll. The results are below."
            if(section == 0) { return 2; }
        } else {
            if(section == 1) { return 0; }
        }
    
        return 4; // Ironically, all sections are 4
    }

    @IBAction func doVote(sender: AnyObject) {
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
