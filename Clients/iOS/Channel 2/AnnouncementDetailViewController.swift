//
//  AnnouncementDetailViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 10/16/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class AnnouncementDetailViewController: UIViewController {

    @IBOutlet var peopleCountLabel: UILabel!
    @IBOutlet var creatorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var fullTextView: UITextView!
    @IBOutlet var iconImageView: UIImageView!
    var isGoing = false;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Get array of information from NSUserDefaults
        if let informationArrayNS = NSUserDefaults.standardUserDefaults().objectForKey("announcementsDetailArray") as? [AnyObject] {
            if let informationArray = informationArrayNS as? [NSString] {
                titleLabel.text = informationArray[0] as String;
                dateLabel.text = informationArray[1] as String;
                creatorLabel.text = informationArray[2] as String;
                fullTextView.text = informationArray[3] as String;
                peopleCountLabel.text = informationArray[4] as String;
            } else {
                print("f1")
            }
        } else {
            print("f2")
        }
        let file = FM(l:"Documents", name: "announcementDetailImage.png")
        if let data = file.read()
        {
            iconImageView.image = UIImage(data: data);
        } else {
            print("f3")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func setAnnouncementTitle(t:String) {
        self.titleLabel.text = t;
    }
    
   override func previewActionItems() -> [UIPreviewActionItem] {
        let regularAction = UIPreviewAction(title: "Hello", style: .Default) { (action: UIPreviewAction, vc: UIViewController) -> Void in
            
        }
        
        let destructiveAction = UIPreviewAction(title: "World", style: .Destructive) { (action: UIPreviewAction, vc: UIViewController) -> Void in
            
        }
        
        let actionGroup = UIPreviewActionGroup(title: "!!!!...", style: .Default, actions: [regularAction, destructiveAction])
        
        return [regularAction, destructiveAction, actionGroup]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }
}
