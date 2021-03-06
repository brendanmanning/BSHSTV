//
//  YouTubeVideoViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/11/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class YouTubeVideoViewController: UIViewController, UIGestureRecognizerDelegate, UIWebViewDelegate {
    private var id:String!
    var defaults = NSUserDefaults.standardUserDefaults();
    var webview = UIWebView();
 
    var askingToRotate = false;
    override func viewDidLayoutSubviews() {
       //let webview = UIWebView(frame: view.frame)
        //webview.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.youtube.com/watch?v=" + self.id)!));
        //view.addSubview(webview)
        
        webview.delegate = self;
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        // Get the video to display
        if let videoID = NSUserDefaults.standardUserDefaults().valueForKey("videoid") as? String {
            self.id = videoID;
        }
        
        // Load the webview, but hide it until device orientation is verified
        webview = UIWebView(frame: self.view.frame)
        if(NSUserDefaults.standardUserDefaults().boolForKey("showStarterVideo"))
        {
            webview.loadRequest(NSURLRequest(URL: NSURL(string: String(NSUserDefaults.standardUserDefaults().valueForKey("starterVideo")!))!));
        } else {
            webview.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.youtube.com/watch?v=" + self.id)!));
        }
        view.addSubview(webview)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func showSafariAlert()
    {}
    
    func closePlayer(sender: UITapGestureRecognizer? = nil) {
        // Unwind VC
        //self.performSegueWithIdentifier("unwindvideovc", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return !((navigationType == UIWebViewNavigationType.FormResubmitted) || (navigationType == UIWebViewNavigationType.FormSubmitted) || (navigationType == UIWebViewNavigationType.LinkClicked));
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
