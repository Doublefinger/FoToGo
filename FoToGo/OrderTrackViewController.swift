//
//  OrderTrackViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 02/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Firebase

class OrderTrackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var orderTable: UITableView!
    var detailViewController: OrderDetailViewController!
    var ref: FIRDatabaseReference!
//    var orderInfos = [OrderInfo] ()
//    var taskSnapshots = [FIRDataSnapshot] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(OrderTrackViewController.removeTask(_:)), name: Notification.Name(rawValue: Constants.NotificationKeys.PickOrder), object: nil)

        
        configureDatabase()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.orderTable.reloadData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationKeys.RemoveBadge), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTrackOrder() {
//        print("enter updatetrack")
//        print(orderInfos.count)
//        let orderInfo = notification.object as! OrderInfo
//        self.orderInfos.append(orderInfo)
    }
    
    func configureDatabase() {
    }
    
    func removeTask(_ notification: NSNotification) {
        //TODO complete the order, then remove task, Test Complete
        
//        var index = -1
//        for taskSnapshot in self.taskSnapshots {
//            if taskSnapshot.key == taskId {
//                index = taskSnapshots.index(of: taskSnapshot)!
//                break
//            }
//        }
//        if index >= 0 {
//            taskSnapshots.remove(at: index)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.orderTable.indexPathForSelectedRow {
                let orderInfo = AppState.sharedInstance.orderInfos?[indexPath.row]
                let controller = (segue.destination as! OrderDetailViewController)
                controller.detailItem = orderInfo
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (AppState.sharedInstance.orderInfos?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.orderTable.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)
        let orderInfo = AppState.sharedInstance.orderInfos?[indexPath.row]
        
        cell.textLabel!.text = (orderInfo?.restaurantName)! + " - " + (orderInfo?.destinationName)!
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
