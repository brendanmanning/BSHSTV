//
//  SportsAPI.swift
//  Channel 2
//
//  Created by Brendan Manning on 3/29/17.
//  Copyright © 2017 BrendanManning. All rights reserved.
//

import UIKit
import Firebase

class SportsAPI: NSObject {
    
    static let api = SportsAPI();
    
    private var _ref = FIRDatabase.database().reference().child("sports").ref;
    
    internal var games = [SportsGame]();
    
    internal var onGameLoaded: ((game:SportsGame) -> Void)?;
    internal var onGameChanged: ((game:SportsGame) -> Void)?;
    
    
    internal func loadGames() {
        
        // Get every game asyncronously
        _ref.observeEventType(.ChildAdded) { (snapshot:FIRDataSnapshot) in
            
            // Convert the snapshot to a SportsGame
            let game = self.snapshotToGame(snapshot);
            
            // Add it to our array
            self.games.append(game);
            
            // Call the programmer defined callback if there is one
            if(self.onGameLoaded != nil) {
                self.onGameLoaded!(game: game);
            }
            
            /*snapshot.ref.observeEventType(.ChildChanged) { (snapshot:FIRDataSnapshot) in
                
                print("Child changed");
                print(snapshot.key);
                print(snapshot.value)

            }*/
        }
        
        // Get updates to the games
        _ref.observeEventType(.ChildChanged) { (snapshot:FIRDataSnapshot) in
            
            print(snapshot.key);
            print(snapshot.value)
            
            // Make sure it is already in the array
            if let index = self.indexOfGame(snapshot.key, inArray: self.games) {
                
                // Convert the snapshot to a SportsGame
                let game = self.snapshotToGame(snapshot);
                
                // Replace it in the array
                self.games[index] = game;
                
                // Call the game updated callback (if we have one)
                if self.onGameChanged != nil {
                    self.onGameChanged!(game: game);
                }
            }/* else {
                // Convert the snapshot to a SportsGame
                let game = self.snapshotToGame(snapshot);
                
                // Add it to our array
                self.games.append(game);
                
                // Call the programmer defined callback if there is one
                if(self.onGameLoaded != nil) {
                    self.onGameLoaded!(game: game);
                }
            }*/
        }
    }
    
    internal func indexOfGame(withid: String, inArray: [SportsGame]) -> Int? {
        for i in 0 ..< inArray.count {
            if inArray[i].id == withid {
                return i;
            }
        }
        
        return nil;
    }
    
    private func snapshotToGame(snapshot:FIRDataSnapshot) -> SportsGame {
        
        // Fill in the basic information from the snapshot
        let team = snapshot.childSnapshotForPath("team").value as! String;
        let opponent = snapshot.childSnapshotForPath("opponent").value as! String;
        let date = snapshot.childSnapshotForPath("date").value as! String;
        let time = snapshot.childSnapshotForPath("time").value as! String;
        let home:Bool = ((snapshot.childSnapshotForPath("home").value as! Int) == 1);
        let us = snapshot.childSnapshotForPath("us").value as! Int;
        let them = snapshot.childSnapshotForPath("them").value as! Int;
        
        var status:SportsGameStatus!;
        
        // Compute the status
        if((snapshot.childSnapshotForPath("final").value as! Int) == 1) {
            status = SportsGameStatus.Final;
        } else {
            status = SportsGameStatus.Scheduled;
        }
        
        // Make this into an instance of SportsGame
        return SportsGame(id: snapshot.key, team: team, opponent: opponent, date: date, time: time, home: home, status: status, us: us, them: them);
    }
    
    private func imageUrlForTeam(team:String, callback: (url:NSURL?) -> Void) {
        // The URL for the image of any team is static/sports/logos/<Team>.png
        let imageRef = FIRStorage.storage().reference().child("static").child("sports").child("logos").child(team + ".png");
        
        // Get the HTTP download URL
        imageRef.downloadURLWithCompletion { url, error in
            
            // Pass the URL (or nil) back to the callback
            callback(url: url);
        }
    }
    
    internal func imageForTeam(team:String, callback: (image: UIImage?) -> Void) {
        // Get the HTTP image URL first
        // Instead of downloading right from Google we get the HTTP url so we can use the caching engine
        imageUrlForTeam(team) { (url) in
            if url != nil {
                // Get the cache
                let cache = Cache();
                
                // If a cached version exists
                if(cache.cachedVersionExists(url!)) {
                    callback(image: cache.get(url!));
                    return;
                }
                
                // If no cached version exists, download the image first
                UIImage.with(url!.absoluteString!, callback: { (image:UIImage?) in
                    if image != nil {
                        // If we got the image, do the callback
                        callback(image: image!);
                        
                        // Also save it in the cache to save time later
                        cache.cache(image!, from: url!);
                    } else {
                        callback(image: nil);
                    }
                })
            }
        }
    }
}

class SportsGame: NSObject {
    
    internal var id:String;
    internal var team:String;
    internal var opponent:String;
    internal var date:NSDate!;
    internal var home:Bool;
    internal var gameDescription:String;
    internal var status:SportsGameStatus;
    internal var us = 0;
    internal var them = 0;
    
    init(id:String, team:String, opponent:String, date:String, time:String, home:Bool, status:SportsGameStatus, us:Int?, them:Int?) {
        
        // Fill in the basic information
        self.id = id;
        self.team = team;
        self.opponent = opponent;
        self.home = home;
        self.status = status;
        
        // If a score was specified, fill it in, otherwise it is already set to 0
        if(us != nil) {
            self.us = us!;
        }
        if(them != nil) {
            self.them = them!;
        }
        
        // Build the description of the game based on the other information
        switch(status) {
        case .Scheduled:
            // If the game hasn't taken place yet, tell when/where it will be
            self.gameDescription = "Support the team at ";
            
            // If the game is home/away
            self.gameDescription += ((home) ? "home" : opponent);
            
            // Now add the date
            self.gameDescription += " on " + date + "."
            
            // Add the time
            self.gameDescription += " The game starts at " + time;
            
            break;
        /*case .Ongoing:
            self.gameDescription = "ONGOING! (Go BSHS!)";
            break;*/
        case .Final:
            self.gameDescription = "[FINAL]";
            break;
        }
    }
    
}

enum SportsGameStatus {
    case Scheduled
    //case Ongoing
    case Final
}
