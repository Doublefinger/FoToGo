//
//  OrderContentTableViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 10/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit
import GMStepper

class OrderContentTableViewController: UITableViewController, UINavigationControllerDelegate {

    var orderItems = [String]()
    var orderQuantities = [Int]()
    var itemIndex = 0
    var newItemFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.leftItemsSupplementBackButton = true
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewItem(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationController?.delegate = self
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! FoodItemTableViewCell
        cell.foodName.text = orderItems[indexPath.row]
        if orderItems[indexPath.row] == "Hit to add food" {
            cell.foodCount.isHidden = true
        } else {
            cell.foodCount.isHidden = false
            cell.foodCount.value = Double(orderQuantities[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        itemIndex = indexPath.row
        return indexPath
    }

    func insertNewItem(_ sender: Any) {
        if newItemFlag {
            return
        }
        newItemFlag = true
        orderItems.append("Hit to add food")
        orderQuantities.append(1)
        itemIndex = orderItems.count - 1
        let indexPath = IndexPath(row: itemIndex, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        performSegue(withIdentifier: Constants.Segues.ShowSearchFood, sender: self)
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
    */
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass index argument
        let controller = segue.destination as! FoodSearchViewController
        controller.orderItemIndex = itemIndex
        
        for index in 0...orderItems.count - 1 {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! FoodItemTableViewCell
            self.orderQuantities[index] = Int(cell.foodCount.value)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? MakeOrderViewController {
            if self.orderItems.count > 0 {
                if self.orderItems[orderItems.count - 1] == "Hit to add food" {
                    self.orderItems.removeLast()
                    self.orderQuantities.removeLast()
                    if self.orderItems.count <= 0 {
                        return
                    }
                }
                controller.orderItems = self.orderItems
                for index in 0...orderItems.count - 1 {
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = tableView.cellForRow(at: indexPath) as! FoodItemTableViewCell
                    self.orderQuantities[index] = Int(cell.foodCount.value)
                }
                controller.orderQuantities = self.orderQuantities
                controller.orderDetailTableView.reloadData()
            }
        }
    }
}
