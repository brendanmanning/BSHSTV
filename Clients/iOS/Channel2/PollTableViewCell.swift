//
//  PollTableViewCell.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/19/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class PollTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var completionBadge: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
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
