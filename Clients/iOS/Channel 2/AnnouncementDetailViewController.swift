//
//  AnnouncementDetailViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 10/16/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class AnnouncementDetailViewController: UIViewController {

    @IBOutlet weak var peopleCountLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fullTextView: UITextView!
    @IBOutlet weak var iconImageView: UIImageView!
    var isGoing = false;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Get array of information from NSUserDefaults
       /* var informationArray = NSUserDefaults.standardUserDefaults().objectForKey("announcementsDetailArray") as! [String];
        titleLabel.text = informationArray[0];
        dateLabel.text = informationArray[1];
        creatorLabel.text = informationArray[2];
        fullTextView.text = informationArray[3];
        peopleCountLabel.text = informationArray[4];
        
        let file = FM(l:"Documents", name: "announcementDetailImage.png")
        iconImageView.image = UIImage(data: file.read()!);*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   /* override func previewActionItems() -> [UIPreviewActionItem] {
        let regularAction = UIPreviewAction(title: "Regular", style: .Default) { (action: UIPreviewAction, vc: UIViewController) -> Void in
            
        }
        
        let destructiveAction = UIPreviewAction(title: "Destructive", style: .Destructive) { (action: UIPreviewAction, vc: UIViewController) -> Void in
            
        }
        
        let actionGroup = UIPreviewActionGroup(title: "Group...", style: .Default, actions: [regularAction, destructiveAction])
        
        return [regularAction, destructiveAction, actionGroup]
    }*/
}
