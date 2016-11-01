//
//  MoreTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 10/31/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row;
        
        switch row {
        //case 0: self.performSegueWithIdentifier("segueToSettings", sender: self); break;
        case 1: self.performSegueWithIdentifier("segueToFeedback", sender: self); break;
        default: break;
        }
    }
}
