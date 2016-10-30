//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Brendan Manning on 10/22/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var eventPicker: WKInterfacePicker!
    
    var session:WCSession!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(WCSession.isSupported()) {
            print("Supported")
            session = WCSession.defaultSession();
            session.delegate = self;
            session.activateSession();
            //[String: [[[String: AnyObject]]]
            session.sendMessage(["announcement":"all"], replyHandler: {(data: [String : AnyObject]) -> Void in
                print("recieving...")
                print(data)
                
                let anyObjArr = data["data"] as! [[String : AnyObject]]
                for o in anyObjArr {
                    
                    print(o["title"])
                }
                
                var announcements = [WKPickerItem]();
                let objectArray:[[String : AnyObject]] = data["data"]! as! [[String : AnyObject]]
                //if let arr = objectArray as? [] {
                    for a in objectArray {
                        let item = WKPickerItem();
                        item.title = a["title"] as! String
                        print("TITLE: " + item.title!)
                        announcements.append(item)
                    }
               /* } else {
                    print("e1")
                }*/
                
                self.eventPicker.setItems(announcements)
                /*for a in _["data"] as [AnyObject] {
                    if let announcementStringArray = a as [String] {
                        let pickerItem = WKPickerItem();
                        //pickerItem
                        
                    }
                }*/
                }, errorHandler: {(error:NSError) -> Void in
                    print(error.localizedDescription)
            });
        } else {
            print("Not supported")
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
      //
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
