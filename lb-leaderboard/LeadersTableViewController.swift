//
//  LeadersTableViewController.swift
//  lb-leaderboard
//
//  Created by Liam Westby on 1/31/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit
import SwiftyJSON

class LeadersTableViewController: UITableViewController {
    var leaderDetailVC: LeaderDetailViewController? = nil
    var leaders: [LeaderEntry] = []
    
    func fetchData() {
        
        let fetchSession = URLSession(configuration: .default)
        let url = URL(string: "http://player-service.mybluemix.net/rank?limit=10")!
        
        let fetchTask = fetchSession.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let data = data {
                        var leaders: [LeaderEntry] = []
                        let results = try? JSON(data: data)
                        
                        for (_, leader):(String, JSON) in results! {
                            let id = leader["id"].string!
                            let name = leader["name"].string!
                            let numWins = leader["stats"]["numWins"].int!
                            let rating = leader["stats"]["rating"].int!
                            let totalGames = leader["stats"]["totalGames"].int!
                            
                            leaders.append(LeaderEntry(id: id, name: name, numWins: numWins, rating: rating, totalGames: totalGames))
                        }
                        
                        self.leaders = leaders
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if !self.splitViewController!.isCollapsed && self.tableView.indexPathForSelectedRow == nil && self.leaders.count > 0 {
                    self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
                    self.performSegue(withIdentifier: "showDetail", sender: self)
                }
            }
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fetchTask.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rating Leaders"
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            leaderDetailVC = (controllers[controllers.count-1] as! UINavigationController).topViewController as? LeaderDetailViewController
        }

        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let leader = leaders[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! LeaderDetailViewController
                controller.leader = leader
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    @IBAction func refresh(_ sender: Any) {
        
        fetchData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return leaders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let leader = leaders[indexPath.row]
        cell.textLabel?.text = leader.name
        cell.detailTextLabel?.text = String(format: "%i", leader.rating)

        return cell
    }
    
    // MARK: - Table view delegate
}
