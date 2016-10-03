//
//  YouTubeVideoViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/11/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import PopupDialog
class YouTubeVideoViewController: UIViewController, UIGestureRecognizerDelegate {
    private var id:String!
    var defaults = NSUserDefaults.standardUserDefaults();
    var webview = UIWebView();
    var popup:PopupDialog!;
    var askingToRotate = false;
    override func viewDidLayoutSubviews() {
       //let webview = UIWebView(frame: view.frame)
        //webview.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.youtube.com/watch?v=" + self.id)!));
        //view.addSubview(webview)
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        // Get the video to display
        self.id = NSUserDefaults.standardUserDefaults().valueForKey("videoid") as! String;
        
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
    {
        let popup = PopupDialog(title: "Video not playing?", message: "Would you like to view it in Safari?")
        let no = PopupDialogButton(title: "No", action: nil)
        let yes = PopupDialogButton(title: "Yes", action: {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.youtube.com/watch?v=" + self.id)!);
        });
        popup.addButtons([no,yes]);
        
        self.presentViewController(popup, animated: true, completion: nil)
    }
    
    func closePlayer(sender: UITapGestureRecognizer? = nil) {
        // Unwind VC
        //self.performSegueWithIdentifier("unwindvideovc", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
