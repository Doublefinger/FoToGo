//
//  OrderDetailViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 02/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

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
    var restPhone, personalPhone: String!
    
    var detailItem: OrderInfo?  {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail = self.detailItem {
            loadPlaceInfo(detail.restId, detail.destId)
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
        }
    }
    
    func loadPlaceInfo(_ restId: String, _ destId: String){
        GMSPlacesClient.shared().lookUpPlaceID(restId) { (place, error) in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.restPhone = place.phoneNumber
            } else {
                print("No place details for \(restId)")
            }
        }
        
        GMSPlacesClient.shared().lookUpPlaceID(destId) { (place, error) in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.restPhone = place.phoneNumber
            } else {
                print("No place details for \(restId)")
            }
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
        return detailItem!.orderItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderItem", for: indexPath)
        if indexPath.row < (detailItem?.orderItems.count)! {
            cell.textLabel?.text = detailItem?.orderItems[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Noteworthy", size: 17.0)
            cell.detailTextLabel?.text = String((detailItem?.orderQuantities[indexPath.row])!)
        } else {
            let font = UIFont(name: "Noteworthy-Bold", size: 18.0)
            cell.textLabel?.text = "Estimate Amount:"
            cell.textLabel?.font = font
            cell.detailTextLabel?.text = detailItem?.estimateCost
            cell.detailTextLabel?.font = font
        }
        return cell
    }
    
    @IBAction func callRestaurant(_ sender: Any) {
        if let phoneNumber = restPhone {
            call(phoneNumber)
        }
    }
    
    @IBAction func callPerson(_ sender: Any) {
        if let phoneNumber = personalPhone {
            call(phoneNumber)
        }
    }
    
    func call(_ phoneNumber: String) {
        let phone = String(phoneNumber.characters.filter{String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
        let url = URL(string: "telprompt://" + phone)
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url!)
            }
        }
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
