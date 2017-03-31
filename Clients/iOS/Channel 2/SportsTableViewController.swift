//
//  SportsTableViewController.swift
//  Channel 2
//
//  Created by Brendan Manning on 3/29/17.
//  Copyright © 2017 BrendanManning. All rights reserved.
//

import UIKit

class SportsTableViewController: UITableViewController {

    private var games = [SportsGame]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare the handlers for the API
        SportsAPI.api.onGameLoaded = { (game:SportsGame) -> Void in
            
            // Add it to the array in memory
            self.games.append(game);
            
            // Reload just the row than changed
            self.tableView.reloadData();
        }
        
        SportsAPI.api.onGameChanged = { (game:SportsGame) -> Void in
            
            // Get the index of the old game
            let index = SportsAPI.api.indexOfGame(game.id, inArray: self.games);
            
            // Make sure it existed
            if index != nil {
                
                // Replace it in the array
                self.games[index!] = game;
                
                // Get the index path of the cell we're updating
                let indexpath = NSIndexPath(forItem: index!, inSection: 0);
                
                // Reload just that table view cell
                self.tableView.reloadRowsAtIndexPaths([indexpath], withRowAnimation: .Automatic);
            }
        }

        // Load all the games from the API
        SportsAPI.api.loadGames();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        print("Memory warning...");
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.games.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sportsCell", forIndexPath: indexPath) as! SportsTableViewCell
        
        cell.loadGame(self.games[indexPath.row]) {
            // Do nothing in the callback
        }

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
