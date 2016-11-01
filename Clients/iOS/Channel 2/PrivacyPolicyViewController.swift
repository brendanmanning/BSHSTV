//
//  PrivacyPolicyViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/1/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    var policyURL = " the BSHS TV App Store page";
    override func viewDidLoad() {
        super.viewDidLoad();
        
        webView.delegate = self;
        if let baseurl = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") {
            if let base = baseurl as? String {
                let urlstr = base + "pages/privacy.html"
                policyURL = urlstr;
                if let url = NSURL(string: urlstr) {
                    webView.loadRequest(NSURLRequest(URL: url));
                }
            }
        }
    }
    @IBAction func closeView(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        Popup().show("Error Loading Privacy Policy", message: "The privacy policy can be found at " + policyURL + ". If you choose to continue using this app, you confirm your consent to the aforementioned terms", button: "Close Message", viewController: self)
    }
}
