//
//  ClubDetailViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/19/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class ClubDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var clubDescriptionLabel: UILabel!
    @IBOutlet weak var clubAdminLabel: UILabel!
    @IBOutlet weak var clubImageView: UIImageView!
    @IBOutlet weak var leaveClubButton: UIButton!
    @IBOutlet weak var clubMeetingsTable: UITableView!
    
    private var meetings = [Announcement]();
    
    private var clubname = "";
    private var clubdescription = "";
    private var clubadmin = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add pre-set data from segue
        clubNameLabel.text = clubname;
        clubDescriptionLabel.text = clubdescription;
        clubAdminLabel.text = clubadmin;
        leaveClubButton.setTitle("Leave " + clubname, forState: .Normal)
        
        // Setup table view.
        clubMeetingsTable.delegate = self;
        clubMeetingsTable.dataSource = self;
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmailToClubAdmin(sender: AnyObject) {
    }

    @IBAction func leaveClub(sender: AnyObject) {
    }
    
    func setAnnouncement(club:Club) {
        self.clubname = club.title;
        self.clubdescription = club.desc;
        self.clubadmin = club.admin;
    }
    
    // MARK: Table View Data Source methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!;
        
        cell.textLabel?.text = formatDate(meetings[indexPath.row].getDate());
        cell.textLabel?.text = meetings[indexPath.row].text;
        
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meetings.count;
    }

    // MARK: Utility methods
    func formatDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "EEEE M/d";
        return dateFormatter.stringFromDate(date);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
