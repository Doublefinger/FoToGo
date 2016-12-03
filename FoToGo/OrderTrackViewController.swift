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
        NotificationCenter.default.addObserver(self, selector: #selector(OrderTrackViewController.removeTask(_:)), name: Notification.Name(rawValue: Constants.NotificationKeys.PickOrder), object: nil)
        configureDatabase()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDatabase() {
        self.ref = FIRDatabase.database().reference()
        self.ref.child("tasks").queryOrdered(byChild: Constants.OrderFields.state).queryEqual(toValue: "pick").observe(.childAdded, with: {[weak self] (snapshot) -> Void in
            guard let strongSelf = self else {
                return
            }
            print("enter order add")
            let task = snapshot.value as! NSDictionary
            
            //I will design the database structure later, this is just for demo purpose
            if !((task[Constants.OrderFields.account] as! String) == AppState.sharedInstance.uid) && !((task[Constants.OrderFields.pickedBy] as! String) == AppState.sharedInstance.uid) {
                return
            }
            let orderInfo = OrderInfo(id: snapshot.key, account: task[Constants.OrderFields.account] as! String, pickedBy: task[Constants.OrderFields.pickedBy] as! String, state: task[Constants.OrderFields.state] as! String, restaurantName: task[Constants.OrderFields.restaurantName] as! String, destinationName: task[Constants.OrderFields.destinationName] as! String)
            strongSelf.orderInfos.append(orderInfo)
            strongSelf.orderTable.insertRows(at: [IndexPath(row: strongSelf.orderInfos.count-1, section: 0)], with: .automatic)
        })
        
//        self.ref.child("tasks").observe(.childChanged, with: { [weak self] (snapshot) in
//            guard let strongSelf = self else {
//                return
//            }
//            let task = snapshot.value as! NSDictionary
//            
//            //I will design the database structure later, this is just for demo purpose
//            if !((task[Constants.OrderFields.account] as! String) == AppState.sharedInstance.uid) && !((task[Constants.OrderFields.pickedBy] as! String) == AppState.sharedInstance.uid) {
//                return
//            }
//            
//            let state = task[Constants.OrderFields.state] as! String
//            switch state {
//            case Constants.OrderStates.pick:
//                strongSelf.taskSnapshots.append(snapshot)
//            case Constants.OrderStates.drop:
//                strongSelf.removeTask(snapshot.key)
//            case Constants.OrderStates.complete:
//                strongSelf.removeTask(snapshot.key)
//            default:
//                return
//            }
//        })
    }
    
    func removeTask(_ notification: NSNotification) {
        print("enterNo")
        print(notification.object)
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
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.taskSnapshots.count
//    }
    
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
//        let madeById = task[Constants.OrderFields.account] as! String
//        let pickedById = task[Constants.OrderFields.pickedBy] as! String
        
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
