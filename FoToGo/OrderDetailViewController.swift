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
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var personView: UIView!
    @IBOutlet weak var placeInfoHeightConstraint: NSLayoutConstraint!
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()

    var restPhone, personalPhone: String!
    
    var detailItem: OrderInfo?  {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail = self.detailItem {
            loadPlaces(detail.restId, detail.destId)
            if detail.pickedBy != "" {
                if detail.account == AppState.sharedInstance.uid {
                    self.loadPerson(detail.pickedBy)
                } else {
                    self.loadPerson(detail.account)
                }
            }
            
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
    
    func loadPerson(_ uid: String) {
        self.ref.child("users").queryOrderedByKey().queryEqual(toValue: uid).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            let userData = snapshot.value as! NSDictionary
            self.personalPhone = userData["mobile"] as? String
            if let label = self.theOtherName {
                label.text = userData["name"] as? String
            }
            let url = userData["imagePath"] as? String
            if url != "" {
                self.loadPersonImage(url!)
            }
        })
    }
    
    func loadPersonImage(_ url: String) {
        FIRStorage.storage().reference(forURL: url).data(withMaxSize: INT64_MAX, completion: { (data, error) in
            if error == nil {
                self.theOtherImage.image = UIImage(data: data!)
            }
        })
    }
    
//    func loadRestaurantOnly(_ restId: String) {
//        GMSPlacesClient.shared().lookUpPlaceID(restId) { (place, error) in
//            if let error = error {
//                print("lookup place id query error: \(error.localizedDescription)")
//                return
//            }
//            if let placeA = place {
//                self.restPhone = placeA.phoneNumber
//            } else {
//                print("No place details for \(restId)")
//            }
//        }
//    }
    
    func loadPlaces(_ restId: String, _ destId: String){
        GMSPlacesClient.shared().lookUpPlaceID(restId) { (place, error) in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let placeA = place {
                self.restPhone = placeA.phoneNumber
                GMSPlacesClient.shared().lookUpPlaceID(destId) { (place, error) in
                    if let error = error {
                        print("lookup place id query error: \(error.localizedDescription)")
                        return
                    }
                    if let placeB = place {
                        let locationA = CLLocation(latitude: placeA.coordinate.latitude, longitude: placeA.coordinate.longitude)
                        let locationB = CLLocation(latitude: placeB.coordinate.latitude, longitude: placeB.coordinate.longitude)
                        if let distance = self.distance {
                            distance.setTitle(String(format: "%.2f", locationA.distance(from: locationB) * 0.000621371) + " miles to restaurant", for: .normal)
                        }
                    } else {
                        print("No place details for \(destId)")
                    }
                }
            } else {
                print("No place details for \(restId)")
            }
        }
        
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: destId) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                guard let firstPhoto = photos?.results.first else {
                    return
                }
                self.loadImageForMetadata(photoMetadata: firstPhoto)
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.destImage.image = photo
            }
        })
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
        guard let detail = detailItem else {
            return
        }
        
        if detail.pickedBy == "" {
            personView.isHidden = true
            let constraint = self.placeInfoHeightConstraint.constraintWithMultiplier(multiplier: 0.375)
            self.contentView.removeConstraint(self.placeInfoHeightConstraint)
            self.contentView.addConstraint(constraint)
            self.contentView.setNeedsLayout()
        }
    }
    
    override func viewWillLayoutSubviews() {
        restImage.layer.cornerRadius = restImage.frame.size.height/2
        theOtherImage.layer.cornerRadius = theOtherImage.frame.size.height/2
        destImage.layer.cornerRadius = destImage.frame.size.height/2
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

extension NSLayoutConstraint {
    func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
