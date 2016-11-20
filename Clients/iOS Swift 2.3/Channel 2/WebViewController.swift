//
//  WebViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/18/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    internal var url:String!;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create a web view
        let webView = UIWebView(frame: view.frame);
        // Add the view
        view.addSubview(webView)
        // Try loading the website
        webView.loadRequest(NSURLRequest(URL: NSURL(string: url!)!));
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
