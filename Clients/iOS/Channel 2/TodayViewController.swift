//
//  TodayViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/19/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    
    // Interface Builder (IBOutlets)
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var swipeDownImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!

    @IBOutlet weak var slideTitleLabel: UILabel!
    var addedFact = false;
    var current = 0;
    var items = [TodayItem]();
    var attemptedRefresh = false;
    var gotDataFromServer = false;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.updateUI(NSDate());
        updateForCurrentSlide()
    }
    @IBAction func nextButtonPressed(sender: AnyObject) {
        goForward(sender)
    }
    @IBAction func lastButtonPressed(sender: AnyObject) {
        goBack(sender)
    }
    @IBAction func goBack(sender: AnyObject) {
        if(current > 0)
        {
            current -= 1;
        } else if (current == 0) {
            current = (items.count - 1);
        }
        
        updateForCurrentSlide()
    }
    
    @IBAction func goForward(sender: AnyObject) {
        if(current < (items.count - 1))
        {
            current += 1;
        } else if(current == (items.count - 1)) {
            current = 0;
        }
        
        updateForCurrentSlide()
    }
    
    func updateForCurrentSlide()
    {
        if(items.count > 0)
        {
            slideTitleLabel.text = items[current].title;
            contentLabel.text = items[current].content;
            pageLabel.text = "Page " + String(current + 1) + " of " + String(items.count);
        } else {
            slideTitleLabel.text = "Loading...."
            contentLabel.text = "This should take no more than a few seconds. Taking longer? Check your network connection"
        }
    }
    
    func updateUI(date:NSDate) {
        // Format the date to how it will be in the file
        let f = NSDateFormatter();
        f.dateFormat = "M-d"
    
        // The string to find within the file
        let dateAsString = f.stringFromDate(date)
        // Search for it
        var today:String!;
        for line in FM(l: "Documents", name: "OnThisDay.txt").lines() {
            if(line.componentsSeparatedByString(":")[0] == dateAsString)
            {
                today = line.stringByReplacingOccurrencesOfString(dateAsString + ":", withString: "")
            }
        }
    
        
        
        f.dateFormat = "EEEE, MMMM dd, yyyy"
        Async.main{
            self.dateLabel.text = "Today is " + f.stringFromDate(NSDate());
        }
        if(today != nil)
        {
            // Update UI
            Async.main {
                if(!self.addedFact)
                {
                    if(NSUserDefaults.standardUserDefaults().boolForKey("onThisDayStatus")) {
                        let factItem = TodayItem();
                        factItem.title = "This Day in History"
                        factItem.content = "On this day " + self.chooseFact(today);
                        self.items.append(factItem)
                        self.addedFact = true;
                    
                        self.slideTitleLabel.text = "This Day in History"
                        self.contentLabel.text = factItem.content;
                        self.pageLabel.text = "Page 1 of " + String(self.items.count);
                        self.current = 0;
                    }
                }
            }
        } else {
            Async.background {
                if(!self.attemptedRefresh)
                {
                    let downloader = DayDownloader();
                    let contents = downloader.get();
                    if(downloader.worked)
                    {
                        if(contents != "")
                        {
                            let fileManager = FM(l: "Documents", name: "OnThisDay.txt")
                            let ok = fileManager.write(contents)
                        }
                    }
                    print("refreshing...")
                    self.attemptedRefresh = true;
                }
            }.main {
                self.updateUI(NSDate());
            }
        }
        
        // Get the information from the server that changes daily
        Async.background {
            if(self.gotDataFromServer == false) {
                let todayDownloader = TodayDownloder();
                let todaysitems = todayDownloader.get()
                for item in todaysitems {
                    var alreadyExists = false;
                    for i in self.items {
                        if i.title == item.title
                        {
                            alreadyExists = true;
                        }
                    }
            
                    if(!alreadyExists)
                    {
                        self.items.append(item)
                    }
                }
                self.gotDataFromServer = true;
                self.updateUI(NSDate())
                print(self.items)
                print("titles")
                for i in self.items
                {
                    print(i.title)
                }
                Async.main {
                    self.updateForCurrentSlide()
                }
            }
        }
    }
    
    // Utility - Some days have lots of significant events, so there may be 2 or more events/births/deaths separated by a '/'
    func chooseFact(facts:String) -> String
    {
        if(facts.containsString("/"))
        {
            // Split on / 
            var factsarr = facts.componentsSeparatedByString("/");
            return factsarr[Int(arc4random_uniform(UInt32(factsarr.count)))]
        }
        
        return facts;
    }
    @IBAction func searchForMore(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.google.com/#q=on+this+date+in+history")!)
    }
    
    @IBAction func openSchoolWebsite(sender: AnyObject) {
       let avc = UIActivityViewController(activityItems: [items[current].content! as NSString], applicationActivities: nil)
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            avc.popoverPresentationController!.sourceView = self.view;
        }
        self.presentViewController(avc, animated: true, completion: nil)
    }
    
}
