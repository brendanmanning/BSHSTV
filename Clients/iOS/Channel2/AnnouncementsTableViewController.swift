//
//  AnnouncementsTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/13/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import UIKit
//import SocketIOClientSwift
import Async
import EventKit
import PopupDialog

class AnnouncementsTableViewController: UITableViewController {
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var announcements = [Announcement]();
    var shouldShowNone = false;
    var refreshButtonDefaultColor = UIColor.blackColor();
    override func viewDidLoad() {
        super.viewDidLoad();
        
        refreshButtonDefaultColor = refreshButton.tintColor!;
        
        /* Setup UIRefreshControl */
        //self.presentViewController(LoadingViewController(), animated: false, completion: nil)
       // Async.background {
            self.refreshTableData()
     //   }
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        self.refreshTableData();
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
                self.announcements = try AnnouncementDownloader().get()
            } catch {
                Async.main {
                    Popup().show("Well this isn't good...", message: "The server failed to send the videos. Please try again later", button: "Dismiss", viewController: self as UIViewController)
                }
            }
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    }
    
    @IBAction func longpressgesture(sender: AnyObject) {
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
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnnouncementCell", forIndexPath: indexPath) as! AnnouncementTableViewCell
        
        var image = UIImage(named: "loading")
        Async.main {
            cell.img.image = image;
            cell.announcementdate.text = "Tap to share, hold to set reminder";//self.announcements[indexPath.item].date
            cell.announcementtitle.text = self.announcements[indexPath.item].eventtitle
            cell.fulltext.text = self.announcements[indexPath.item].text;
            cell.creator.text = self.announcements[indexPath.item].creator;
            }.background {
                image = self.imageFromURL(self.announcements[indexPath.item].imagelink)
            }.main {
                cell.img.image = image;
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
            if let data = NSData(contentsOfURL: url)
            {
                return UIImage(data: data)!
            }
        }
        
        return UIImage(named: "ImageNotFound")!
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
            let pop = PopupDialog(title: "We can't access your calendar", message: "The Channel 2 app needs your permission to add events to your calendar")
            let linkbutton = PopupDialogButton(title: "Take me to settings!", action: {
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            let dismissbutton = PopupDialogButton(title: "Dismiss", action: nil)
            pop.addButtons([dismissbutton,linkbutton])
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
            Popup().show("Something's not right here", message: "We ran into an unknown error.", button: "Dismiss", viewController: self as! UIViewController)
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
        let popup = PopupDialog(title: t, message: m)
        let button = PopupDialogButton(title: "Okay", action: nil)
        popup.addButton(button);
        self.presentViewController(popup, animated: true, completion: nil)
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
    
}
