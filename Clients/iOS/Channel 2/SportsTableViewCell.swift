//
//  SportsTableViewCell.swift
//  Channel 2
//
//  Created by Brendan Manning on 3/29/17.
//  Copyright © 2017 BrendanManning. All rights reserved.
//

import UIKit

class SportsTableViewCell: UITableViewCell {

    @IBOutlet weak var ourLogo: UIImageView!
    @IBOutlet weak var theirLogo: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var theirLabel: UILabel!
    @IBOutlet weak var ourScore: UILabel!
    @IBOutlet weak var theirScore: UILabel!
    @IBOutlet weak var gameStatusLabel: UILabel!
    
    func loadGame(game: SportsGame, callback: (() -> Void)?) {
        // Asyncronously load the game into the cell
        
        // Load the basics that are built right into the object
        teamLabel.text = game.team;
        theirLabel.text = game.opponent;
        ourScore.text = String(game.us);
        theirScore.text = String(game.them);
        gameStatusLabel.text = game.gameDescription;
        
        // If the game hasn't started yet, don't show the score labels (duh)
        self.ourScore.hidden = (game.status == .Scheduled);
        self.theirScore.hidden = (game.status == .Scheduled);
        
        // Now load the logos for our team and theirs in the background from Firebase
        
        // Get our's first (we're Shanahan)
        SportsAPI.api.imageForTeam("Shanahan") { (image) in
            if image != nil {
                self.ourLogo.image = image;
            } else {
                self.ourLogo.image = UIImage(named: "Confused")!;
            }
            print("Got our logo...");
        }
        
        // Get the other teams next
        SportsAPI.api.imageForTeam(game.opponent) { (image) in
            if image != nil {
                self.theirLogo.image = image!;
            } else {
                self.theirLogo.image = UIImage(named: "Confused")!;
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
