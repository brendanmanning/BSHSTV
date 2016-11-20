//
//  SongRequestViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 11/14/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
class SongRequestViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Get base url from NSUserDefs
        if let baseUrl = NSUserDefaults.standardUserDefaults().valueForKey("phpserver") {
            if let base = baseUrl as? String {
                if let url = NSURL(string: base + "requestsong.php") {
                    webView.loadRequest(NSURLRequest(URL: url));
                }
            }
        }
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
