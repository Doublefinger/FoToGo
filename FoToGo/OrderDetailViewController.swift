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

class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var destName: UILabel!
    @IBOutlet weak var theOtherName: UILabel!
    @IBOutlet weak var deliverBefore: UILabel!
    @IBOutlet weak var deliverAfter: UILabel!
    
    @IBOutlet weak var locationVerified: UIButton!
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
    var inputAmountAlert, amountConfirmAlert, arrivedAlert, completeAlert: UIAlertController!
    var taskId: String!
    var inRestaurant = 0
    
    var detailItem: OrderInfo?  {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail = self.detailItem {
            taskId = detail.id
            if detail.paidAmount != "" {
                self.switchToUploadButton()
            }
            
            if detail.state >= Constants.OrderStates.arrived {
                if let button = self.arrived {
                    button.isHidden = true
                }
            }
            
            if detail.paymentLocationVerified == 1 {
                locationVerified.isHidden = false
            }
            
            loadPlaces(detail.restId, detail.destId)
            if detail.pickedBy != "" {
                if detail.account == AppState.sharedInstance.uid {
                    self.hideButtons()
                    self.loadPerson(detail.pickedBy)
                } else {
                    self.configuareAlert()
                    self.loadPerson(detail.account)
                }
            } else {
                self.hideButtons()
            }
            
            if let label = self.restName {
                label.text = detail.restAddress.name
            }
            
            if let label = self.destName {
                label.text = detail.destAddress.name
            }

            if let label = self.orderState {
                label.text = Helper.displayState(detail.state)
            }
            
            if let label = self.deliverBefore {
                label.text = "Deliver Before: " + Helper.displayDateInLocalInMins(detail.deliverBefore)
            }
            
            if let label = self.deliverAfter {
                label.text = "Deliver After: " + Helper.displayDateInLocalInMins(detail.deliverAfter)
            }
            
            if let imageView = self.restImage {
                imageView.image = detail.photo
            }
        }
    }
    
    func hideButtons() {
        if let button = self.readyToGo {
            button.isHidden = true
        }
        
        if let button = self.arrived {
            button.isHidden = true
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
    
    func switchToUploadButton() {
        if let button = self.readyToGo {
            button.setImage(UIImage(named: "Screenshot Filled-30"), for: .normal)
        }
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
    
    @IBAction func dropOrder(_ sender: Any) {
        
    }

    @IBAction func readyToDeliver(_ sender: Any) {
        guard let location = AppState.sharedInstance.location else {
            let alert = UIAlertController(title: "Warning!", message: "GPS access is restricted. To confirm your paid amount, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go to settings now", style: .default, handler: { (alert: UIAlertAction!) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let place = self.detailItem?.restAddress.location else {
            return
        }
        
        if place.distance(from: location) > 50 {
            inRestaurant = 0
            let alert = UIAlertController(title: "Warning!", message: "System cannot detect your arrival at " + (detailItem?.restAddress.name)!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Wait", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Ignore", style: .default, handler: { (action) in
                self.present(self.inputAmountAlert, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            //input amount of the food
            inRestaurant = 1
            self.present(inputAmountAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func arrive(_ sender: Any) {
        guard let detail = detailItem else {
            return
        }
        
        guard let location = AppState.sharedInstance.location else {
            let alert = UIAlertController(title: "Warning!", message: "GPS access is restricted. To confirm your paid amount, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go to settings now", style: .default, handler: { (alert: UIAlertAction!) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if detail.destAddress.location.distance(from: location) > 500 {
            let alert = UIAlertController(title: "Sorry", message: "Our system has not detacted your arrival, please try it later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Later", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)        }
        if detail.paidAmount == "" {
            let alert = UIAlertController(title: "Not yet", message: "Please use the dollar button to input your paid amount first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.present(arrivedAlert, animated: true, completion: nil)
        }
    }

    @IBAction func completeOrder(_ sender: Any) {
        guard let detail = detailItem else {
            return
        }
        if detail.account == AppState.sharedInstance.uid {
            //person who will pay want to complete the order
            if detail.paidAmount == "" {
                let alert = UIAlertController(title: "Not yet", message: "Your deliveryman has not confirm the paid amount", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                completeAlert = UIAlertController(title: "Confirmation", message: "You agree to pay $" + detail.paidAmount, preferredStyle: .alert)
                completeAlert.addAction(UIAlertAction(title: "Pay", style: .default, handler: { (action) in
                    self.updateOrderField(Constants.OrderFields.state, Constants.OrderStates.attemptToPay)
                    //pay
                    
                    //rating
                    
                }))
                completeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.completeAlert.dismiss(animated: true, completion: nil)
                }))
                self.present(completeAlert, animated: true, completion: nil)
            }
        } else {
            if detail.paidAmount != "" {
                let alert = UIAlertController(title: "Not yet", message: "Please use the dollar button to input your paid amount first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                completeAlert = UIAlertController(title: "Request $" + detail.paidAmount + "?", message: "You will receive the payment in your wallet, once the buyer agrees to pay.", preferredStyle: .alert)
                completeAlert.addAction(UIAlertAction(title: "Pay", style: .default, handler: { (action) in
                    self.updateOrderField(Constants.OrderFields.state, Constants.OrderStates.paymentRequested)
                }))
                completeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.completeAlert.dismiss(animated: true, completion: nil)
                }))
                self.present(completeAlert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if detailItem?.pickedBy == AppState.sharedInstance.uid {
            AppState.sharedInstance.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppState.sharedInstance.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(OrderDetailViewController.updateDetailItem(notification:)), name: Notification.Name(rawValue: Constants.NotificationKeys.UpdateOrderDetail), object: nil)
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
    
    func updateDetailItem (notification: Notification) {
        self.detailItem = notification.object as? OrderInfo
    }
    
    func configuareAlert() {
        amountConfirmAlert = UIAlertController(title: "", message: "Please double check your paid amount", preferredStyle: .alert)
        amountConfirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            let amountText = self.amountConfirmAlert.title!
            let amount = amountText.substring(from: amountText.index(after: amountText.startIndex))
            self.detailItem?.paidAmount = amount
            if let detail = self.detailItem {
                let path = "tasks/" + detail.id + "/"
                self.ref.updateChildValues([path + Constants.OrderFields.paidAmount : amount, path + Constants.OrderFields.state: Constants.OrderStates.delivering, path + Constants.OrderFields.paymentLocationVerified: self.inRestaurant])
                self.orderItemTable.reloadData()
                self.switchToUploadButton()
            }
        }))
        
        amountConfirmAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            self.amountConfirmAlert.dismiss(animated: true, completion: nil)
        }))
        
        inputAmountAlert = UIAlertController(title: "Ready To Deliver?", message: "Input the amount you paid", preferredStyle: .alert)
        inputAmountAlert.addTextField { (textfield) in
            textfield.delegate = self
            textfield.placeholder = "$"
        }
        inputAmountAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            let textfield = self.inputAmountAlert.textFields![0]
            if textfield.text != "" {
                self.amountConfirmAlert.title = "$" + textfield.text!
                self.present(self.amountConfirmAlert, animated: true, completion: nil)
            }
        }))
        
        inputAmountAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            self.inputAmountAlert.dismiss(animated: true, completion: nil)
        }))
        
        arrivedAlert = UIAlertController(title: "You arrived?", message: "Click yes to let the person know you have arrived", preferredStyle: .alert)
        arrivedAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.orderState.text = "Arrived"
            self.updateOrderField(Constants.OrderFields.state, Constants.OrderStates.arrived)
        }))
        
        arrivedAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            self.arrivedAlert.dismiss(animated: true, completion: nil)
        }))
    }
    
    func updateOrderField(_ key: String, _ value: Any) {
        let path = "tasks/" + taskId + "/"
        self.ref.child(path + key).setValue(value)
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
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
            if self.detailItem?.paidAmount != "" {
                cell.textLabel?.text = "Paid Amount"
                cell.detailTextLabel?.text = self.detailItem?.paidAmount
            } else {
                cell.textLabel?.text = "Estimate Amount:"
                cell.detailTextLabel?.text = detailItem?.estimateCost
            }
        }
        return cell
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
