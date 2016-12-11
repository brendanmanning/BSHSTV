//
//  NewPollDetailViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/22/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class NewPollDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSelector: UISegmentedControl!
    @IBOutlet weak var choices: UIPickerView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var prompt: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    var voting = false;
    var voter:OnlineVoter!;
    var poll:OnlinePoll!;
    
    var selectedIndex = -1;
    
    var timer:NSTimer!;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableView.hidden = true;
        choices.hidden = true;
        submitButton.enabled = false;
        submitButton.hidden = true;
        
       // self.voter = OnlineVoter(poll:String(NSUserDefaults.standardUserDefaults().integerForKey("pollid")));
        
        view.backgroundColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) : UIColor.whiteColor();
        choices.tintColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.whiteColor() : choices.tintColor;
        prompt.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.whiteColor() : UIColor.blackColor()
        subtitle.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.whiteColor() : UIColor.blackColor()
        tableView.backgroundColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) : UIColor.whiteColor();
        
        self.prompt.text = "Loading"
        self.subtitle.text = "Please be patient"
        
        Async.background {
            self.voter = OnlineVoter(poll:String(NSUserDefaults.standardUserDefaults().integerForKey("pollid")));
            
        }.main {
            self.choices.hidden = self.voter.didAlreadyVotedInPoll();
            self.submitButton.hidden = self.voter.didAlreadyVotedInPoll();
            if(self.voter.didAlreadyVotedInPoll())
            {
                self.viewSelector.setTitle("Poll Question", forSegmentAtIndex: 0)
            }
                
            self.poll = OnlinePoll();
            do {
                        
                    self.poll = try PollDownloader().get(NSUserDefaults.standardUserDefaults().integerForKey("pollid"));
                    self.prompt.text = self.poll.prompt!;
                    self.subtitle.text = (self.poll.desc! != "") ? "(" + self.poll.desc! + ")" : "";
                    self.submitButton.enabled = self.viewSelector!.selectedSegmentIndex == 0;
                    self.selectedIndex = 0;
                    self.choices.dataSource = self;
                    self.choices.delegate = self;
                    self.choices.reloadAllComponents();
                    self.tableView.reloadData();
            } catch {
                print("Caught error");
            }
        }
    }
    
    func animate() {
        if self.prompt.text?.characters.count == ("Loading".characters.count + 3) {
            self.prompt.text = "Loading"
        } else {
            self.prompt.text = self.prompt.text! + ".";
        }
    }
    
    func startAnimating() {
        timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(NewPollDetailViewController.animate), userInfo: nil, repeats: true)

    }
    
    func stopAnimating() {
        timer.invalidate()
    }
    
    @IBAction func submitPoll(sender: AnyObject) {
        if(selectedIndex != -1) {
            self.voting = true;
            self.submitButton.setTitle("Voting...", forState: .Normal)
            self.submitButton.enabled = false;
            Async.background {
                if(!self.voter.vote(self.selectedIndex + 1)) {
                    Async.main {
                        Popup().show("Error Voting", message: "Please try again later", button: "OK", viewController: self)
                        self.submitButton.setTitle("Submit Vote", forState: .Normal)
                        self.submitButton.enabled = true;
                    }
                } else {
                    Async.main {
                        self.submitButton.setTitle("Voted!", forState: .Normal)
                        self.voter.remember();
                        self.voting = false;
                    }
                }
            }
        }
    }
    
    @IBAction func selectedView(sender: AnyObject) {
        if(!voting) {
            if(viewSelector.selectedSegmentIndex == 0) {
                show(true)
            } else {
                show(false)
            }
        }
    }
    
    func show(vote:Bool) {
        self.tableView.hidden = vote;
        self.prompt.hidden = !vote;
        self.subtitle.hidden = !vote;
        self.submitButton.hidden = !vote && !self.voter.didAlreadyVotedInPoll();
        self.submitButton.enabled = vote && !self.voter.didAlreadyVotedInPoll();
        self.selectedIndex = 0;
        self.choices.hidden = !vote && !self.voter.didAlreadyVotedInPoll();
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let p = poll {
            return p.choices().count;
        } else {
            return 0;
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row;
        submitButton.enabled = !voter.didAlreadyVotedInPoll();
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let p = poll {
            return NSAttributedString(string: p.choice(row), attributes: [NSForegroundColorAttributeName:UpgradeManager.sharedInstance.standardTextColor()])
        }
        
        return nil;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let p = poll { return p.choices().count; } else { return 0; }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultCell") as! PollResultsTableViewCell;
        cell.choice.text = self.poll.choices()[indexPath.row]
        cell.progress.progress = self.poll.getPercents()[indexPath.row];
        
        // Theme customization
        cell.backgroundColor = UpgradeManager.sharedInstance.standardBackgroundColor();
        cell.choice.textColor = UpgradeManager.sharedInstance.standardTextColor();
        
        return cell;
    }
}
