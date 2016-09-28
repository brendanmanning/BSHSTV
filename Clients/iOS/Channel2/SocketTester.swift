//
//  SocketTester.swift
//  Channel 2
//
//  Created by Brendan Manning on 8/30/16.
//  Copyright © 2016 BrendanManning. All rights reserved.
//
/*
import SocketIOClientSwift

// Tries to reach the LAN and Fallback server. Returns a socket for the one (if any) that works

import UIKit

class SocketTester: NSObject {
    internal var hostOne:NSURL!
    internal var hostTwo:NSURL!
    
    internal var hostOneFailed = false;
    internal var hostTwoFailed = false;
    
    init(lan:NSURL, fallback:NSURL)
    {
        self.hostOne = lan;
        self.hostTwo = fallback;
    }
    
    internal func test() -> Bool { // True if at least one server was reachable
        // Test main server
        do {
            let cone = try String(contentsOfURL: hostOne!)
            print("ONE - " + cone);
            return true;
        } catch {
            print("Connection to 1 (" + hostOne.absoluteString + ") failed");
            print((error as NSError).localizedDescription)
            self.hostOneFailed = true;
            do {
                let ctwo = try String(contentsOfURL: hostTwo!)
                print("TWO - " + ctwo);
                return true;
            } catch {
                self.hostTwoFailed = true;
                print("Connection to 2 (" + hostTwo.absoluteString + ") failed");
                print((error as NSError).localizedDescription)
            }
        }
        
        // The wonders of boolean logic
        return false;

    }
    
    /*internal func getWorkingSocket() -> SocketIOClient?
    {
        if(!self.hostOneFailed){
            return SocketIOClient(socketURL: hostOne)
        } else if(!self.hostTwoFailed) {
            return SocketIOClient(socketURL: hostTwo)
        } else {
            return nil;
        }
    }
    
    internal func socketNumber() -> Int {
        if(!self.hostOneFailed) {
            return 1;
        } else if(!self.hostTwoFailed) {
            return 2;
        } else {
            return 0;
        }
    }*/
    
    private func statusCodeOK(url:NSURL) -> Bool {
        var statusisok = false;
        
        var request: NSURLRequest = NSURLRequest(URL: url)
        var response: NSURLResponse?
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {urlData, response, reponseError in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print("code \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200)
                {
                 //   self.statusisok = true;
                }
            }
            
        }
        return statusisok
        task.resume()
    }
}*/
