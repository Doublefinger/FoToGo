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
    var orderInfos = [OrderInfo] ()
//    var taskSnapshots = [FIRDataSnapshot] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(self, selector: #selector(OrderTrackViewController.removeTask(_:)), name: Notification.Name(rawValue: Constants.NotificationKeys.PickOrder), object: nil)
        configureDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDatabase() {
        self.ref = FIRDatabase.database().reference()
        self.ref.child("tasks").queryOrdered(byChild: Constants.OrderFields.account).queryEqual(toValue: AppState.sharedInstance.uid).observe(.childAdded, with: {[weak self] (snapshot) -> Void in
            guard let strongSelf = self else {
                return
            }
            let task = snapshot.value as! NSDictionary
            
            let orderInfo = OrderInfo(id: snapshot.key, account: task[Constants.OrderFields.account] as! String, pickedBy: task[Constants.OrderFields.pickedBy] as! String, state: task[Constants.OrderFields.state] as! String, restaurantName: task[Constants.OrderFields.restaurantName] as! String, destinationName: task[Constants.OrderFields.destinationName] as! String)
            strongSelf.orderInfos.append(orderInfo)
            strongSelf.orderTable.insertRows(at: [IndexPath(row: strongSelf.orderInfos.count-1, section: 0)], with: .automatic)
        })
        
        self.ref.child("tasks").queryOrdered(byChild: Constants.OrderFields.pickedBy).queryEqual(toValue: AppState.sharedInstance.uid).observe(.childAdded, with: {[weak self] (snapshot) -> Void in
            guard let strongSelf = self else {
                return
            }
            let task = snapshot.value as! NSDictionary
            
            let orderInfo = OrderInfo(id: snapshot.key, account: task[Constants.OrderFields.account] as! String, pickedBy: task[Constants.OrderFields.pickedBy] as! String, state: task[Constants.OrderFields.state] as! String, restaurantName: task[Constants.OrderFields.restaurantName] as! String, destinationName: task[Constants.OrderFields.destinationName] as! String)
            strongSelf.orderInfos.append(orderInfo)
            strongSelf.orderTable.insertRows(at: [IndexPath(row: strongSelf.orderInfos.count-1, section: 0)], with: .automatic)
        })
    }
    
    func removeTask(_ notification: NSNotification) {
        //TODO complete the order, then remove task
        
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
                let orderInfo = orderInfos[indexPath.row]
                let controller = (segue.destination as! OrderDetailViewController)
                controller.detailItem = orderInfo
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.orderTable.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath)
        let orderInfo  = self.orderInfos[indexPath.row]
        
        cell.textLabel!.text = "From: " + orderInfo.restaurantName + " - To: " + orderInfo.destinationName
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
