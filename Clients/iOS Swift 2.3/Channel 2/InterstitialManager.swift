//
//  InterstitialManager.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/9/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import GoogleMobileAds
class InterstitialManager: NSObject {
    private var inter:GADInterstitial!;
    override init() {
        self.inter = GADInterstitial(adUnitID: "{AD_UNIT_ID}");
        let request = GADRequest();
        request.testDevices = [kGADSimulatorID];
        inter.loadRequest(request)
        
        print("inited")
    }
    func presentIfReady(vc:UIViewController) -> Bool {
        print("presenting...")
        if(inter.isReady) {
            self.inter.presentFromRootViewController(vc)
            return true;
        }
        
        return false;
    }
    
    func ready() -> Bool {
        return inter.isReady;
    }
    
}
