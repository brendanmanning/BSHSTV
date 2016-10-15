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
    
    @IBAction func doCheckin(sender: AnyObject) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        fulltext.userInteractionEnabled = false;
    }
       
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
