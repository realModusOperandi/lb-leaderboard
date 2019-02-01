//
//  LeadersTableViewController.swift
//  lb-leaderboard
//
//  Created by Liam Westby on 1/31/19.
//  Copyright © 2019 me. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate struct LeaderEntry {
    public let id: String
    public let name: String
    public let numWins: Int
    public let rating: Int
    public let totalGames: Int
}

class LeadersTableViewController: UITableViewController {
    fileprivate var leaders: [LeaderEntry] = []
    
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
            }
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fetchTask.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rating Leaders"

        fetchData()
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
