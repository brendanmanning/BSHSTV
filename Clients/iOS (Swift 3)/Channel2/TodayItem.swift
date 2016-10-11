//
//  TodayItem.swift
//  Channel 2
//
//  Created by Brendan Manning on 9/25/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class TodayItem: NSObject {
    internal var title:String!;
    internal var content:String!;
    private var buttonTitle:String!;
    private var buttonURL:NSURL!;
    private var buttonEnabled = false;
    
    internal func enableButton(withTitle:String,withURL:String!)
    {
        buttonTitle = withTitle;
        
        if let url = NSURL(string: withURL)
        {
            buttonURL = url;
            buttonEnabled = true;
        }
    }
    
    func buttonOkay() -> Bool {
        return (buttonTitle != nil && buttonURL != nil && buttonEnabled == true)
    }
}
