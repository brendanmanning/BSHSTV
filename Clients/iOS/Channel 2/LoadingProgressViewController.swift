//
//  LoadingProgressViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 12/4/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import Async

class LoadingProgressViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    private var LOGO_MIN_ALPHA:CGFloat = 30;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        logo.alpha = LOGO_MIN_ALPHA;
        
        Async.background {
            while(true) {
                UIView.animateWithDuration(0.5, animations: {
                    self.logo.alpha = 1.0;
                })
                
                UIView.animateWithDuration(0.5, animations: {
                    self.logo.alpha = self.LOGO_MIN_ALPHA;
                })
            }
        }
    }
}
