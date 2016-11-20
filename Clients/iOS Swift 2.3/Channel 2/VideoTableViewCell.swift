
//
//  VideoTableViewCell.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/11/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellView.backgroundColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) : UIColor.whiteColor()
        
        title.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.whiteColor() : UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0);
        
        subtitle.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.grayColor() : UIColor.blackColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
