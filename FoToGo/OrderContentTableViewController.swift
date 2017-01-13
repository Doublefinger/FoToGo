//
//  OrderContentTableViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 10/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit

class OrderContentTableViewController: UITableViewController {

    @IBOutlet var orderItemTableView: UITableView!
    var orderItems = [String]()
    var orderQuantities = [Int]()
    var newItemFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.leftItemsSupplementBackButton = true
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewItem(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderItems.count
    }
    
    func insertNewItem(_ sender: Any) {
        if newItemFlag {
            return
        }
        newItemFlag = true
        orderItems.append("Hit to add item")
        orderQuantities.append(1)
        let indexPath = IndexPath(row: 0, section: 0)
        self.orderItemTableView.insertRows(at: [indexPath], with: .automatic)
        performSegue(withIdentifier: Constants.Segues.ShowSearchFood, sender: self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = orderItems[indexPath.row]
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
