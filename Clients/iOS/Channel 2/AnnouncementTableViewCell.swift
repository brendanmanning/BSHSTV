//
//  AnnouncementTableViewCell.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/13/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import PopupDialog
class AnnouncementTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var announcementtitle: UILabel!
    @IBOutlet weak var fulltext: UITextView!
    @IBOutlet weak var announcementdate: UILabel!
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var checkinsLabel: UILabel!
    internal var checkins = -1;
    @IBOutlet weak var cellView: UIView!
    
    @IBAction func doCheckin(sender: AnyObject) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //fulltext.userInteractionEnabled = false;
        self.cellView.backgroundColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) : UIColor.whiteColor()
        
        self.announcementtitle.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.whiteColor() : UIColor(red:0.00, green:0.59, blue:0.00, alpha:1.0);
        
        self.creator.textColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor.grayColor() : UIColor.blackColor();
    }
       
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
