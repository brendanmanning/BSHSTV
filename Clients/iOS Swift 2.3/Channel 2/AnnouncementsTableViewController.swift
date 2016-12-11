//
//  AnnouncementsTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/13/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
import Async
import EventKit
import SwiftyJSON
import WatchConnectivity
class AnnouncementsTableViewController: UITableViewController {
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var announcements = [Announcement]();
    var shouldShowNone = false;
    var refreshButtonDefaultColor = UIColor.blackColor();
    var firsttime = true;
    var reloadMetadata = true;
    var defaultCellColor:UIColor!;
    //var session:WCSession!;
    override func viewDidLoad() {
        super.viewDidLoad();
        
        refreshButtonDefaultColor = refreshButton.tintColor!;
        
        self.tableView.backgroundColor = (UpgradeManager.sharedInstance.proEnabled()) ? UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0) : UIColor.whiteColor()

        Async.background {
            self.refreshTableData()
            self.firsttime = false;
        }
        //}
        
        //broadCastAnnouncements();
    }
    /*
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        broadCastAnnouncements()
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let ann = message["announcement"] as? String {
            if(ann == "all") {
                var array = [AnyObject]();
                for a in announcements {
                    if let arr = stringArrayForAnnouncement(a) {
                        array.append(arr);
                    }
                }
                print("sending...")
                print(["data":array]);
                replyHandler(["data":array])
            } else {
                
            }
        }
    }
    
    private func broadCastAnnouncements() {
        var array = [AnyObject]();
        for a in announcements {
            if let arr = stringArrayForAnnouncement(a) {
                array.append(arr);
            }
        }
        print("sending...")
        print(["data":array]);
        if(session.reachable) {
            session.sendMessage(["data":array], replyHandler: nil, errorHandler: {(error:NSError) -> Void in Popup().show("error", message: "send message failed", button: "dismiss", viewController: self as UIViewController); });
        } else {
            do {
                try session.updateApplicationContext(["data": array])
            } catch {
                print("Application context update failed")
                Popup().show("error", message: "application context update failed", button: "dismiss", viewController: self as UIViewController)
            }
        }
    }
    
    private func stringArrayForAnnouncement(announcement:Announcement) -> [String : AnyObject]? {
        if let annid = announcement.id {
            if let announcementToSend = announcementForId(annid) {
                let id = announcementToSend.id;
                let title = announcementToSend.eventtitle;
                let text = announcementToSend.text;
                let date = announcementToSend.date;
                return ["id":id, "title":title, "text":text, "date":date];
            }
        }
        
        return nil;
    }
    */
    private func announcementForId(id:Int) -> Announcement? {
        for a in announcements {
            if a.id == id {
                return a;
            }
        }
        
        return nil;
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        Async.background {
            self.reloadMetadata = true;
            self.refreshTableData();
        }
    }
    func refresh(sender:AnyObject)
    {
        self.refreshTableData();
    }
    func refreshTableData()
    {
        refreshButton.enabled = false;
        UIView.animateWithDuration(0.5, animations: {
            self.refreshButton.tintColor = UIColor.clearColor()
        })
        
        // Download the announcements as JSON
        Async.background {
            do {
                let anndownloader = AnnouncementDownloader();
                anndownloader.vc = self as UIViewController;
                self.announcements = try anndownloader.get()
            } catch {}
        }.main {
            self.refreshButton.enabled = true;
            UIView.animateWithDuration(1.0, animations: {
                self.refreshButton.tintColor = UIColor.greenColor();
            })
            UIView.animateWithDuration(1.0, animations: {
                self.refreshButton.tintColor = self.refreshButtonDefaultColor;
            })
                self.tableView.reloadData();
                print("refreshed")
        }
        
        // Handle a non working Internet connection
        if(!isInternetWorking())
        {
            Popup().show("Some features unavailable", message: "Your internet connection doesn't seem to be working. As a result, some features might not work as expected. Please recheck your Internet connection", button: "Dismiss", viewController: self as UIViewController)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(shouldShowNone) { return 0; }
        return announcements.count;
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Confirm check what the default event for a click is
        // 0 = none
        // 1 = calendar
        // 2 = share
        
        var preference = NSUserDefaults.standardUserDefaults().integerForKey("announcementaction")
        // Setup the date formatter
        let formatter = NSDateFormatter();
        formatter.dateFormat = "EEEE, MMMM d, yyyy at h:mm:a"
        
        // Check if the item has not date (if date is set to 1/1/1970 12:00 AM)
        if(!announcements[indexPath.row].dateValid())
        {
            preference = -1;
            Popup().show("Can't share this event", message: "Either the date is invalid or sharing was explicity denied to this event", button: "Dismiss", viewController: self as UIViewController)
        }
        
        if(preference == 1)
        {
            // Ask the user if they want to add the event to their calendar
            let p = PopupDialog(title: "Add to calendar?", message: "Should we add this event to your calendar?")
            let y = PopupDialogButton(title: "Yes", action: {
                self.addToCalendar(indexPath.item)
            })
            let n = PopupDialogButton(title: "No", action: nil)
            p.addButtons([y,n])
            self.presentViewController(p, animated: true, completion: nil)
        } else if(preference == 3) {
            let text = "Event: " + announcements[indexPath.item].eventtitle + " / " + "About: " + announcements[indexPath.item].text +  " / Date: " + formatter.stringFromDate(announcements[indexPath.item].getDate())
            let activityVC = UIActivityViewController(activityItems: [text as AnyObject],applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.presentViewController(activityVC, animated: true, completion: nil)
            
        } else if(preference == 2)
        {
            var saidyes = true;
            var notificationsDisabled = false;
            if(UIApplication.sharedApplication().isRegisteredForRemoteNotifications() == false)
            {
                let popup = PopupDialog(title: "Send a Push Notification?", message: "We'll remind you 15 minutes before the event. If you say yes, we'll confirm your permission on the next screen", image: UIImage(named: "NotificationIcon"), gestureDismissal: true, completion: nil);
                let yesbutton = PopupDialogButton(title: "Yes please!", action: {
                    let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType([.Alert, .Badge, .Sound]), categories: nil)
                    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                })
                let nobutton = PopupDialogButton(title: "No thanks!", action: { saidyes = false })
                popup.addButtons([yesbutton,nobutton])
                self.presentViewController(popup, animated: true, completion: nil)
            }
            if(saidyes) {
                //if(UIApplication.sharedApplication().isRe)
                //{
                    if(announcements[indexPath.item].dateValid() == false) { return; }
                    let notificationsInQueue = 0;//NSUserDefaults.standardUserDefaults().integerForKey("notifications")
                    if(notificationsInQueue < 64) // Maximum number of queued local notifications   allowed by iOS is 64
                    {
                        var notification = UILocalNotification();
                        let calendar = NSCalendar.currentCalendar()
                        notification.fireDate = calendar.dateByAddingUnit(.Minute, value: -15, toDate: announcements[indexPath.item].getDate(), options: []);
                        notification.alertBody = announcements[indexPath.item].eventtitle + " is in 15 minutes"
                        notification.alertTitle = announcements[indexPath.item].creator;
                        print(notification.fireDate)
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        Popup().show("Reminder Scheduled 👏", message: "A notification will be sent 15 minutes before the start of the event", button: "Great!", viewController: self as UIViewController)
                    } else {
                        Popup().show("Hmmmm. Something's not right here", message: "Your notification did not schedule due to an internal error", button: "Dismiss", viewController: self as UIViewController)
                    }
              /*  } else {
                    print("Not registeredd")
                }*/
            } else {
                print("said no")
            }
        }
    }*/
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        updatedefaults();
        /*Async.background {
            if(self.sayImGoingToEvent(indexPath))
            {
                self.refreshTableData()
            } else {
                Async.main {
                    if let eventsAlreadyGoingTo = NSUserDefaults.standardUserDefaults().objectForKey("alreadyGoingToArray") as? [String]
                    {
                        /* IF THE USER TRIED TO VOTE ON SOMETHING THEY ALREADY VOTED ON, DON'T BOTHER TO SHOW A POPUP */
                         
                        if(!eventsAlreadyGoingTo.contains(String(self.announcements[indexPath.row].id))) {
                            Popup().show("Network Error", message: "The app failed to connect with the server", button: "Dismiss", viewController: self as UIViewController)
                        } else {
                            let popup = PopupDialog(title: self.announcements[indexPath.row].eventtitle, message: "You and at least " + String(self.announcements[indexPath.row].peopleGoing - 1) + " other people are attending", image: self.announcements[indexPath.row].uiimg, gestureDismissal: true, completion: nil)
                            popup.addButton(PopupDialogButton(title: "Dismiss", action: nil))
                            self.presentViewController(popup, animated: true, completion: nil)
                        }
                    }
                }
            }
        }*/
    }
    
    
    
    /*@IBAction func longpressgesture(sender: AnyObject) {
       let recognizer = sender as! UIGestureRecognizer
        
        //if(recognizer.state == UIGestureRecognizerState.Ended)
      //  {
        var saidno = false;
        if(UIApplication.sharedApplication().isRegisteredForRemoteNotifications() == false)
        {
            let popup = PopupDialog(title: "Turn on Push Notifications?", message: "We'll send you a notification 15 minutes before the event.", image: UIImage(named: "NotificationIcon"), gestureDismissal: true, completion: nil);
            let yesbutton = PopupDialogButton(title: "Yes please!", action: {
                let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType([.Alert, .Badge, .Sound]), categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            })
            let nobutton = PopupDialogButton(title: "No thanks!", action: { saidno = true })
            popup.addButtons([yesbutton,nobutton])
            self.presentViewController(popup, animated: true, completion: nil)
        }
        if(UIApplication.sharedApplication().isRegisteredForRemoteNotifications())
        {
        let location = recognizer.locationInView(self.tableView)
            if let indexpath = tableView.indexPathForRowAtPoint(location)
            {
                if let cell = self.tableView.cellForRowAtIndexPath(indexpath)
                {
                    if(announcements[indexpath.row].datevalid == false) { return; }
                    let notificationsInQueue = 0;//NSUserDefaults.standardUserDefaults().integerForKey("notifications")
                    if(notificationsInQueue < 64) // Maximum number of queued local notifications allowed by iOS is 64
                    {
                        var notification = UILocalNotification();
                        let calendar = NSCalendar.currentCalendar()
                        notification.fireDate = calendar.dateByAddingUnit(.Minute, value: -15, toDate: announcements[indexpath.item].getDate(), options: []);
                        notification.alertBody = announcements[indexpath.item].eventtitle + " is in 15 minutes"
                        notification.alertTitle = announcements[indexpath.item].creator;
                        
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        UIApplication.sharedApplication().applicationIconBadgeNumber += 1;
                        
                        Popup().show("Reminder Scheduled 👏", message: "A notification will be sent 15 minutes before the start of the event", button: "Great!", viewController: self as UIViewController)
                    } else {
                        print("e4")
                    }
                } else {
                    print("e3")
                }
            } else {
                print("e2")
            }
       /* } else {
            print("e1")
        } */
        } else {
            if(saidno == false) // If we weren't explicitly told not to show a notification
            {
                let alert = PopupDialog(title: "Notifications disabled", message: "We need your permission to send a notification. To grant this permission, go to Settings->Channel 2->Notifications->Turn Allow Notifications On")
                let dismiss = PopupDialogButton(title: "Dismiss", action: nil)
                alert.addButton(dismiss)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }*/

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    
        let cell = tableView.dequeueReusableCellWithIdentifier("AnnouncementCell", forIndexPath: indexPath) as! AnnouncementTableViewCell
    
        //31,33,36
        
        print(UpgradeManager.sharedInstance.proEnabled())
        /* Make the cell green if the user already committed to this event */
        /*if let eventsAlreadyGoingTo = NSUserDefaults.standardUserDefaults().objectForKey("alreadyGoingToArray") as? [String]
        {
            /* The app saves an array containing every event the user has already committed to. This way they can't say they're going twice.
             * The server would stop that anyway
             */
            if(eventsAlreadyGoingTo.contains(String(announcements[indexPath.row].id)))
            {
                cell.backgroundColor = UIColor(red:0.00, green:0.59, blue:0.00, alpha:0.5);
            } else {
                cell.backgroundColor = defaultCellColor;
            }
        }*/
        
        if(reloadMetadata) {
            var image = UIImage(named: "loading")
            Async.main {
                cell.img.image = image;
                //cell.announcementdate.text = "Tap to share, hold to set reminder";//self.announcements[indexPath.item].date
                cell.announcementtitle.text = self.announcements[indexPath.item].eventtitle
                print(self.announcements[indexPath.row].peopleGoing);
                // cell.fulltext.text = self.announcements[indexPath.item].text;
                if(self.announcements[indexPath.row].peopleGoing != -1) {
                    //cell.fulltext.text = self.announcements[indexPath.item].text + "\n" + String(self.announcements[indexPath.item].peopleGoing) + "+ people are attending";
                }
                cell.creator.text = self.announcements[indexPath.row].creator;
                }.background {
                    image = self.imageFromURL(self.announcements[indexPath.row].imagelink)
                    self.announcements[indexPath.row].uiimg = image;
                }.main {
                    cell.img.image = image;
                    //print(cell.fulltext.text);
                }
        }
        
        return cell;
    }
    func imageFromURL(imageURL:String) -> UIImage {
        if(imageURL.hasPrefix("local:"))
        {
            if let localImage =  UIImage(named:imageURL.stringByReplacingOccurrencesOfString("local:", withString: "")) {
                return localImage;
            } else {
                return UIImage(named: "ImageNotFound")!;
            }
        }
        if let url = NSURL(string: imageURL.stringByReplacingOccurrencesOfString("[slash]", withString: "/"))
        {
            let cacher = Cache();
            if(cacher.cachedVersionExists(url)) {
                return cacher.get(url)!
            } else {
                if let data = NSData(contentsOfURL: url)
                {
                    let img = UIImage(data: data)!
                    cacher.cache(img, from: url)
                    return img;
                }
            }
        }
        
        return UIImage(named: "Image")!
    }
    
    func isInternetWorking() -> Bool
    {
        /* If Google's homepage isn't loading, it's safe to assume the user's connection isn't working */
        if let url = NSURL(string: "https://www.apple.com/index.html")
        {
            do {
                let str = try String(contentsOfURL: url)
                print("o1")
                return true;
            } catch { print("e2");return false; }
        }
        print("e1")
        return false;
    }
    
    func addToCalendar(index:Int)
    {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            insertEvent(eventStore, index: index)
            break;
        case .Denied:
            // not allowed
            let pop = UIAlertController(title: "We can't access your calendar", message: "The Channel 2 app needs your permission to add events to your calendar", preferredStyle: .Alert)
            let linkbutton = UIAlertAction(title: "Settings", style: .Default, handler: ({ (_) in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
            }));
            let dismissbutton = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            pop.addActions([dismissbutton,linkbutton])
            pop.preferredAction = linkbutton;
            self.presentViewController(pop, animated: true, completion: nil)
            break;
        case .NotDetermined:
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {[weak self] (granted:Bool, error:NSError?) -> Void in
                if granted {
                   self?.insertEvent(eventStore, index: index)
                } else {
                    Popup().show("We ran into some trouble...", message: "We're sorry. It looks like we couldn't get permission to use your calendar. That's all we know.", button: "Dismiss", viewController: self! as UIViewController)
                }
                })
            break;
        default:
            // Show default error
            Popup().show("Something's not right here", message: "We ran into an unknown error.", button: "Dismiss", viewController: self as UIViewController)
            break;
        }
        
    }
    
    func insertEvent(store:EKEventStore, index:Int)
    {
        var t:String!;
        var m:String!;
        if(addEvent(store, index: index))
        {
            t = "Success 😄👏"
            m = "Event " + announcements[index].eventtitle + " added to your Calendar!"
        } else {
            t = "Something went wrong 😢"
            m = "Please try again later"
        }
        Popup().show(t, message: m, button: "Okay!", viewController: self)
    }
    
    func addEvent(store:EKEventStore, index:Int) -> Bool
    {
        let calendars = store.calendarsForEntityType(EKEntityType.Event) 
        
        let start = announcements[index].getDate();
        // Error checking
        if(!announcements[index].datevalid)
        {
            return false;
        }
        // Default time length is 1 hours
        let enddate = start.dateByAddingTimeInterval(1 * 60 * 60);
        // Create event object
        let event = EKEvent(eventStore: store);
        // add the calendar (the event will be added to every calendar in the user's phone)
        event.calendar = store.defaultCalendarForNewEvents;
        event.startDate = start;
        event.endDate = enddate;
        event.title = announcements[index].eventtitle;
        event.notes = announcements[index].text + " (Announcement from " + announcements[index].creator + ") * Duration of event subject to change. Channel 2 has no way of knowing an event's length, therefore it is marked for 1 hour by default. *"
        
        // Add the event with error handling
        do {
            try store.saveEvent(event, span: EKSpan.ThisEvent);
            return true;
        } catch {
            return false;
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let formatter = NSDateFormatter();
            formatter.dateFormat = "EEEE, MMMM d, yyyy at h:mm:a"
            let text = "Event: " + self.announcements[indexPath.item].eventtitle + " / " + "About: " + self.announcements[indexPath.item].text +  " / Date: " + formatter.stringFromDate(self.announcements[indexPath.item].getDate())
            let activityVC = UIActivityViewController(activityItems: [text as AnyObject],applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.presentViewController(activityVC, animated: true, completion: nil)
        });
        shareAction.backgroundColor = UIColor.blueColor();
        
        let addToCalendarAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Add to Calendar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.addToCalendar(indexPath.item)
        });
        addToCalendarAction.backgroundColor = UIColor.greenColor();
        
        return [shareAction,addToCalendarAction]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToAnnouncementDetail" || segue.identifier == "segueToAnnouncementDetailPeek"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print(announcements[indexPath.row].eventtitle);
                
                /* The data for this segue gets saved to NSUserDefaults
                 * Below is what index each value will be saved in 
                 * [0] title
                 * [1] date
                 * [2] creator
                 * [3] full text
                 * [4] people going
                */
                /*
                let vco = segue.destinationViewController
                if let vc = (segue.destinationViewController as! UINavigationController).topViewController as? AnnouncementDetailViewController {
                    
                    
                vc.setAnnouncementTitle(announcements[indexPath.row].eventtitle)
                vc.creatorLabel.text = announcements[indexPath.row].creator;
                
                /* Format the date */
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EEEE MMM d, yyyy [h:mm a]"
                let dateString = formatter.stringFromDate(announcements[indexPath.row].getDate())
                vc.dateLabel.text = dateString;
                
                vc.iconImageView.image = announcements[indexPath.row].uiimg;
                vc.fullTextView.text = announcements[indexPath.row].text;
                
                /* Format the count of people going */
                if(announcements[indexPath.row].peopleGoing != -1) {
                    vc.peopleCountLabel.text = String(announcements[indexPath.row].peopleGoing) + "+"
                } else {
                    vc.peopleCountLabel.text = "MANY";
                }
                }  else {
                    print("vc conversion failed")
                }
                
                */
                
            } else {
                print("count not get indexath")
            }
        }
    }
    
    func updatedefaults() {
        if let indexPath = self.tableView.indexPathForSelectedRow {
        let file = FM(l:"Documents", name: "announcementDetailImage.png")
        if(file.exists()) {
            file.delete()
        }
        file.writeData(UIImageJPEGRepresentation( announcements[indexPath.row].uiimg!, CGFloat(1))!);
        
        var peoplestring = "";
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE MMM d, yyyy [h:mm a]"
        let dateString = formatter.stringFromDate(announcements[indexPath.row].getDate())
        if(announcements[indexPath.row].peopleGoing != -1) {
            peoplestring = String(announcements[indexPath.row].peopleGoing) + "+"
        } else {
            peoplestring = "MANY";
        }
        var array = [NSString]();
        array.append(announcements[indexPath.row].eventtitle);
        array.append(dateString)
        array.append(announcements[indexPath.row].creator);
        array.append(announcements[indexPath.row].text)
        array.append(peoplestring)
        //array.append(String(announcements[indexPath.row].id) as NSString);
        
        NSUserDefaults.standardUserDefaults().setObject(array, forKey: "announcementsDetailArray")
        
        
        NSUserDefaults.standardUserDefaults().setInteger(announcements[indexPath.row].id, forKey: "announcementID")
        
        NSUserDefaults.standardUserDefaults().setValue(announcements[indexPath.row].imagelink, forKey: "announcementImageLink")
            
            print(NSUserDefaults.standardUserDefaults().synchronize());
        } else {
            print("index path fail")
        }
    }
}
