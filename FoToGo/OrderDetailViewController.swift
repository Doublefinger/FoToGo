//
//  OrderDetailViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 02/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Firebase

class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var destName: UILabel!
    @IBOutlet weak var theOtherName: UILabel!
    @IBOutlet weak var deliverBefore: UILabel!
    @IBOutlet weak var deliverAfter: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var readyToGo: UIButton!
    @IBOutlet weak var arrived: UIButton!
    @IBOutlet weak var delivered: UIButton!
    @IBOutlet weak var distance: UIButton!
    
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var destImage: UIImageView!
    @IBOutlet weak var theOtherImage: UIImageView!
    
    @IBOutlet weak var orderItemTable: UITableView!
    
    var ref: FIRDatabaseReference!
    var orderItems = [String]()
    var orderQuantities = [Int]()
    var estimateCost: String!
    
    var detailItem: OrderInfo?  {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail = self.detailItem {
            if let label = self.restName {
                label.text = detail.restaurantName
            }
            
            if let label = self.destName {
                label.text = detail.destinationName
            }

            if let label = self.orderState {
                label.text = detail.state
            }
            
            if let label = self.deliverBefore {
                label.text = "Deliver Before: " + Helper.displayDateInLocalInMins(detail.deliverBefore)
            }
            
            if let label = self.deliverAfter {
                label.text = "Deliver After: " + Helper.displayDateInLocalInMins(detail.deliverAfter)
            }

//            if detail.account == AppState.sharedInstance.uid {
//                if let label = self.theOtherName {
//                    label.text = AppState.sharedInstance.displayName!
//                    self.configureDatabase(queryId: detail.pickedBy);
//                }
//            } else {
//                if let label = self.theOtherName {
//                    label.text = label.text! + " " + AppState.sharedInstance.displayName!
//                    self.configureDatabase(queryId: detail.account);
//                }
//            }
            
            if let imageView = self.restImage {
                imageView.image = detail.photo
            }
            
            self.estimateCost = detail.estimateCost
            self.orderItems = detail.orderItems
            self.orderQuantities = detail.orderQuantities
        }
    }
    
    func configureDatabase(queryId: String) {
        self.ref = FIRDatabase.database().reference()
        
//        self.ref.child("users").queryOrderedByKey().queryEqual(toValue: queryId).observeSingleEvent(of: .childAdded, with: {[weak self] (snapshot) -> Void in
//            guard let strongSelf = self else {
//                return
//            }
//            let user = snapshot.value as! NSDictionary
//            strongSelf.mobile.text = strongSelf.mobile.text! + (user[Constants.UserFields.mobile] as! String)
//            if strongSelf.detailItem?.account == AppState.sharedInstance.uid {
//                strongSelf.pickedBy.text = strongSelf.pickedBy.text! + (user[Constants.UserFields.name] as! String)
//            } else {
//                strongSelf.requestedBy.text = strongSelf.requestedBy.text! + (user[Constants.UserFields.name] as! String)
//            }
//        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureView()
    }
    
    override func viewDidLayoutSubviews() {
        restImage.layer.cornerRadius = restImage.frame.size.height/2
        restImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - TableView
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderItem", for: indexPath)
        if indexPath.row < orderItems.count {
            cell.textLabel?.text = orderItems[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Noteworthy", size: 17.0)
            cell.detailTextLabel?.text = String(orderQuantities[indexPath.row])
        } else {
            cell.textLabel?.text = "Estimate Amount:"
            cell.textLabel?.font = UIFont(name: "Noteworthy-Bold", size: 18.0)
            cell.detailTextLabel?.text = estimateCost
            cell.detailTextLabel?.font = UIFont(name: "Noteworthy-Bold", size: 18.0)
        }
        return cell
    }
    
    @IBAction func callRestaurant(_ sender: Any) {
    }
    
    @IBAction func callPerson(_ sender: Any) {
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
