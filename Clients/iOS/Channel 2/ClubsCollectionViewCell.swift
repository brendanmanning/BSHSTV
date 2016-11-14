//
//  ClubsCollectionViewCell.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/1/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class ClubsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moderatorLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    override func awakeFromNib() {
        self.titleLabel.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.whiteColor() : UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0);
        self.moderatorLabel.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.grayColor() : UIColor.blackColor();
    }
}
