//
//  FeedbackViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/1/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController , UIWebViewDelegate{
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        loadFeedback()
    }
    
    func loadFeedback() {
        if let server = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") {
            if let serverstring = server as? String {
                var feedbackURL = serverstring + "pages/feedback.php";
                if NSUserDefaults.standardUserDefaults().objectForKey("user_name") != nil {
                    if let name = NSUserDefaults.standardUserDefaults().stringForKey("user_name") {
                        feedbackURL += "?name=" + name.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!;
                        print(feedbackURL)
                    }
                }
                if let url = NSURL(string: feedbackURL) {
                    webView.loadRequest(NSURLRequest(URL: url))
                    webView.delegate = self;
                }
            }
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {

    }
}
