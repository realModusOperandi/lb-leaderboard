//
//  LeaderDetailViewController.swift
//  lb-leaderboard
//
//  Created by Liam Westby on 2/1/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit

class LeaderDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var gamesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configure()
    }
    
    func configure() {
        
        if let name = nameLabel,
            let wins = winsLabel,
            let rating = ratingLabel,
            let games = gamesLabel {
            if let leader = leader {
                name.text = leader.name
                wins.text = String(leader.numWins)
                rating.text = String(leader.rating)
                games.text = String(leader.totalGames)
            } else {
                name.text = "Player"
                wins.text = ""
                rating.text = ""
                games.text = ""
            }
        }
        
    }
    
    var leader: LeaderEntry? {
        didSet {
            configure()
        }
    }
    
}
