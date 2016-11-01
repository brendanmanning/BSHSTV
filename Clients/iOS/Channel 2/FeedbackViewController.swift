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
                let feedbackURL = serverstring + "pages/feedback.php";
                if let url = NSURL(string: feedbackURL) {
                    webView.loadRequest(NSURLRequest(URL: url))
                    webView.delegate = self;
                }
            }
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let errorAlert = UIAlertController(title: "Error", message: "You are not connected to the Internet", preferredStyle: .Alert)
        let reloadButton = UIAlertAction(title: "Reload", style: .Default, handler: {(_) -> Void in
            self.loadFeedback()
        })
        let closeButton = UIAlertAction(title: "Close", style: .Default, handler: {(_) -> Void in self.performSegueWithIdentifier("segueToExit", sender: self)
        })
        errorAlert.addAction(reloadButton)
        errorAlert.addAction(closeButton)
        
        errorAlert.preferredAction = closeButton
        
        self.presentViewController(errorAlert, animated: false, completion: nil)
    }
    
    @IBAction override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //
    }
    
    @IBAction func exitFeedback(sender: AnyObject) {
        self.performSegueWithIdentifier("segueToExit", sender: self)
    }
}
