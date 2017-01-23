//
//  OrderTrackViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 02/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class OrderTrackViewController: UITableViewController {

    @IBOutlet var orderTable: UITableView!
    
    var detailViewController: OrderDetailViewController!

    var orderInfos = [OrderInfo] ()
//    var taskSnapshots = [FIRDataSnapshot] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(OrderTrackViewController.removeTask(_:)), name: Notification.Name(rawValue: Constants.NotificationKeys.PickOrder), object: nil)
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
//        self.orderTable.reloadData()
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
    
    func configureTableView() {
        for snapshot in AppState.sharedInstance.inProcessOrders {
            let task = snapshot.value as! NSDictionary
            self.loadTable(placeID: task[Constants.OrderFields.restaurantId] as! String, key: snapshot.key, task: task)
        }
    }
    
    func loadTable(placeID: String, key: String, task: NSDictionary) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
                self.buildTable(key: key, task: task, photo: UIImage(named: "Building Filled-70")!)
            } else {
                guard let firstPhoto = photos?.results.first else {
                    self.buildTable(key: key, task: task, photo: UIImage(named: "Building Filled-70")!)
                    return
                }
                self.loadImageForMetadata(photoMetadata: firstPhoto, key: key, task: task)
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, key: String, task: NSDictionary) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
                self.buildTable(key: key, task: task, photo: UIImage(named: "Building Filled-70")!)
            } else {
                self.buildTable(key: key, task: task, photo: photo!)
//                self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
    }
    
    func buildTable(key: String, task: NSDictionary, photo: UIImage) {
        let orderDetail = task[Constants.OrderFields.orderContent] as! NSDictionary
        var orderItems = [String]()
        var orderQuantities = [Int]()
        for (item, count) in orderDetail {
            orderItems.append(item as! String)
            orderQuantities.append(count as! Int)
        }
        let orderInfo = OrderInfo(id: key, account: task[Constants.OrderFields.account] as! String, pickedBy: task[Constants.OrderFields.pickedBy] as! String, state: task[Constants.OrderFields.state] as! String, restId: task[Constants.OrderFields.restaurantId] as! String, restaurantName: task[Constants.OrderFields.restaurantName] as! String, photo: photo, destId: task[Constants.OrderFields.destinationId] as! String, destinationName: task[Constants.OrderFields.destinationName] as! String, lastUpdate: task[Constants.OrderFields.madeTime] as! String, deliverBefore: task[Constants.OrderFields.deliverBefore] as! String, deliverAfter: task[Constants.OrderFields.deliverAfter] as! String, orderItems: orderItems, orderQuantities: orderQuantities, estimateCost: task[Constants.OrderFields.estimateCost] as! String)
        self.orderInfos.append(orderInfo)
        self.orderTable.insertRows(at: [IndexPath(row: self.orderInfos.count-1, section: 0)], with: .automatic)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.orderTable.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        let orderInfo = self.orderInfos[indexPath.row]
        cell.textLabel!.text = orderInfo.restaurantName
        let time = Helper.displayDateInLocal(orderInfo.lastUpdate)
        let index = time.index(time.startIndex, offsetBy: 5)
        cell.detailTextLabel!.text = time.substring(from: index)
        cell.imageView?.image = orderInfo.photo
        cell.orderState.text = orderInfo.state
        return cell
    }

    /*
    // MARK: - Navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.orderTable.indexPathForSelectedRow {
                let orderInfo = self.orderInfos[indexPath.row]
                let controller = (segue.destination as! OrderDetailViewController)
                controller.detailItem = orderInfo
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = orderInfo.restaurantName + " - " + orderInfo.destinationName
            }
        }
    }
}
