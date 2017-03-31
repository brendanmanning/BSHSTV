//
//  PollTableViewCell.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/19/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class PollTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var completionBadge: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cellView.backgroundColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) : UIColor.whiteColor()
        
        titleLabel.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.whiteColor() : UIColor.blackColor()
        
        promptLabel.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.grayColor() : UIColor.blackColor()
        // Initialization code
    }

    @IBAction func choiceChanged(sender: AnyObject) {
    }
    @IBAction func vote(sender: AnyObject) {
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
