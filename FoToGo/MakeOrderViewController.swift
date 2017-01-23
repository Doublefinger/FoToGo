//
//  MakeOrderViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 21/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

class MakeOrderViewController: UIViewController {

    @IBOutlet weak var start: UITextField!
    @IBOutlet weak var end: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var openStatus: UIButton!
    @IBOutlet weak var orderDetailTableView: UITableView!
    
    var clearAlert: UIAlertController!
    var orderItems = [String]()
    var orderQuantities = [Int]()
    
    var estimateCost: String = "0.00"

    var deliverAfterTime = Date()
    var deliverBeforeTime = Calendar.current.date(byAdding: .minute, value: 30, to: Date())
    var cashOnlyFlag = false
    
    var startAutocompleteController, endAutocompleteController: GMSAutocompleteViewController!
    var markerA, markerB: GMSMarker!
    var placeA, placeB: GMSPlace!
    var ref : FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ref = FIRDatabase.database().reference()
        
        startAutocompleteController = GMSAutocompleteViewController()
        startAutocompleteController.delegate = self
        endAutocompleteController = GMSAutocompleteViewController()
        endAutocompleteController.delegate = self
        
        let postButton = UIBarButtonItem(image: UIImage(named: "Sent-30"), style: UIBarButtonItemStyle.done, target: self, action: #selector(post(_:)))
        //let postButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(post(_:)))
        self.navigationItem.rightBarButtonItem = postButton
        let clearButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(confirmClear))
        self.navigationItem.leftBarButtonItem = clearButton
        self.navigationItem.title = "Make Your Order"
        self.configureClearAlert()
        self.displayCurrentLocation()
    }
    
    func displayCurrentLocation() {
        GMSPlacesClient.shared().currentPlace { (placeLikelihoodlist, error) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            if let placeLikelihoodList = placeLikelihoodlist {
                let place = placeLikelihoodList.likelihoods[0].place
                self.markerB.map = nil
                self.markerB = GMSMarker(position: place.coordinate)
                self.markerB.title = place.name
                self.markerB.map = self.mapView
                self.markerB.icon = UIImage(named: "FF-30")
                self.end.text = "Current Location"
                self.placeB = place
                self.mapView.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
            }
        }
    }
    
    func configureClearAlert() {
        clearAlert = UIAlertController(title: "Confirmation", message: "Refill your order?", preferredStyle: .alert)
        clearAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.clear()
        }))
        
        clearAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            self.clearAlert.dismiss(animated: true, completion: nil)
        }))
    }
    
    @IBAction func openWebsite(_ sender: Any) {
        if placeA != nil {
            if let url = placeA.website {
                if UIApplication.shared.canOpenURL(url as URL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(placeA.website!, completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }

    @IBAction func call(_ sender: Any) {
        if placeA != nil {
            if let phoneNumber = placeA.phoneNumber {
                let phone = String(phoneNumber.characters.filter{String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil })
                print(phone)
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
        }
    }
    
    @IBAction func editPlaceA(_ sender: Any) {
        self.present(startAutocompleteController, animated: true, completion: nil)
    }

    @IBAction func editPlaceB(_ sender: Any) {
        self.present(endAutocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func changePaymentOption(_ sender: UISwitch) {
        cashOnlyFlag = sender.isOn
    }
    
    func post(_ sender: Any) {
        guard let startText = self.start.text else {
            return
        }
        
        guard let endText = self.end.text else {
            return
        }
        
        if startText == "" || endText == "" {
            return
        }
        
        if orderItems.count <= 0 {
            return
        }
        
        //if the date is outdated
        if deliverAfterTime > deliverBeforeTime! {
            return
        }
        
        if deliverBeforeTime! < Calendar.current.date(byAdding: .minute, value: 15, to: Date())! {
            return
        }
        
        //generate task info
        let postTaskAlert = UIAlertController(title: "Confirmation", message: startText + " - " + endText, preferredStyle: .alert)
        postTaskAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.sendTask(start: startText, end: endText)
        }))
        
        postTaskAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            postTaskAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(postTaskAlert, animated: true, completion: nil)
    }
    
    func confirmClear() {
        self.present(clearAlert, animated: true, completion: nil)
    }
    
    func clear() {
        self.start.text = ""
        self.end.text = ""
        self.mapView.clear()
        self.orderItems = [String]()
        self.orderQuantities = [Int]()
        self.cashOnlyFlag = false
        self.estimateCost = "0.00"
        let currentTime = Date()
        self.deliverAfterTime = currentTime
        self.deliverBeforeTime = Calendar.current.date(byAdding: .minute, value: 30, to: currentTime)
        self.orderDetailTableView.reloadData()
        placeA = nil
        placeB = nil
        self.displayCurrentLocation()
    }
    
    func sendTask(start: String, end: String) {
        self.tabBarController?.selectedIndex = 0
        var tData = [String: Any]()
        tData[Constants.OrderFields.account] = AppState.sharedInstance.uid
        tData[Constants.OrderFields.pickedBy] = ""
        tData[Constants.OrderFields.restaurantName] = start
        tData[Constants.OrderFields.destinationName] = end
        tData[Constants.OrderFields.restaurantLatitude] = placeA.coordinate.latitude
        tData[Constants.OrderFields.restaurantLongitude] = placeA.coordinate.longitude
        tData[Constants.OrderFields.destinationLatitude] = placeB.coordinate.latitude
        tData[Constants.OrderFields.destinationLongitude] = placeB.coordinate.longitude
        tData[Constants.OrderFields.state] = Constants.OrderStates.wait
        tData[Constants.OrderFields.madeTime] = Helper.convertDate(Date())
        tData[Constants.OrderFields.restaurantId] = placeA.placeID
        tData[Constants.OrderFields.destinationId] = placeB.placeID
        tData[Constants.OrderFields.checked] = "no"
        var orderContent = [String: Int]()
        
        //orderItems.count is guaranteed to be at least 1
        for index in 0...orderItems.count - 1 {
            orderContent[orderItems[index]] = orderQuantities[index]
        }
        tData[Constants.OrderFields.orderContent] = orderContent
        tData[Constants.OrderFields.cashOnly] = cashOnlyFlag ? 1 : 0
        tData[Constants.OrderFields.deliverAfter] = Helper.convertDate(deliverAfterTime)
        tData[Constants.OrderFields.deliverBefore] = Helper.convertDate(deliverBeforeTime!)
        tData[Constants.OrderFields.estimateCost] = estimateCost
        
        self.ref.child("tasks").childByAutoId().setValue(tData, withCompletionBlock: { (error, ref) -> Void in
            self.clear()
        })
    }

    /*
    // MARK: - Navigation
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.Segues.ShowEstimateCost:
                let controller = segue.destination as! EstimateCostViewController
                controller.estimateCostText = estimateCost
                break
            case Constants.Segues.ShowDeliverAfterTime:
                let controller = segue.destination as! DeliverAfterTimeViewController
                controller.expectedTime = deliverAfterTime
                break
            case Constants.Segues.ShowDeliverBeforeTime:
                let controller = segue.destination as! DeliverBeforeTimeViewController
                controller.expectedTime = deliverBeforeTime
                break
            case Constants.Segues.ShowOrderContent:
                let controller = segue.destination as! OrderContentTableViewController
                controller.orderItems = self.orderItems
                controller.orderQuantities = self.orderQuantities
                break
            default:
                break
            }
        }
    }
}

extension MakeOrderViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if viewController == startAutocompleteController {
            markerA.map = nil
            self.start.text = place.name
            markerA = GMSMarker(position: place.coordinate)
            markerA.title = place.name
            markerA.icon = UIImage(named: "Restaurant Pickup-30")
            markerA.map = mapView
            placeA = place
        } else {
            markerB.map = nil
            markerB = GMSMarker(position: place.coordinate)
            markerB.title = place.name
            markerB.map = mapView
            markerB.icon = UIImage(named: "FF-30")
            self.end.text = place.name
            placeB = place
        }
        if placeA != nil && placeB != nil {
            let latitude = (placeA.coordinate.latitude + placeB.coordinate.latitude) / 2
            let longitude = (placeA.coordinate.longitude + placeB.coordinate.longitude) / 2
            mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14)
        } else {
            mapView.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        }
        
        if placeA != nil {
            switch placeA.openNowStatus {
            case .yes:
                openStatus.setTitle("Open Now", for: .disabled)
            case .no:
                openStatus.setTitle("Closed", for: .disabled)
            default:
                openStatus.setTitle("Unknown", for: .disabled)
            }
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        if viewController == startAutocompleteController {
            markerA = nil
            self.start.text = ""
            placeA = nil
        } else {
            markerB = nil
            self.end.text = ""
            placeB = nil
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension MakeOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = UIImage(named: "More Than-30")
        switch indexPath.row {
        case 0:
            let cell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: "orderDetailCell") as! OrderDetailCell
            cell.title.text = "Order Detail"
            if orderItems.count > 0 {
                cell.detail.text = orderItems[0] + "..."
            } else {
                cell.detail.text = "none"
            }
            cell.goDetail.image = image
            return cell
        case 1:
            let cell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: "estimateCostCell") as! EstimateCostCell
            cell.title.text = "Estimate Cost"
            cell.detail.text = estimateCost
            cell.goDetail.image = image
            return cell
        case 3:
            let cell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: "deliverAfterTimeCell") as! DeliverAfterTimeCell
            cell.title.text = "Deliver After"
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            cell.detail.text = formatter.string(from: deliverAfterTime)
            cell.goDetail.image = image
            return cell
        case 4:
            let cell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: "deliverBeforeTimeCell") as! DeliverBeforeTimeCell
            cell.title.text = "Deliver Before"
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            cell.detail.text = formatter.string(from: deliverBeforeTime!)
            cell.goDetail.image = image
            return cell
        default:
            let cell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: "paymentMethodCell") as! PaymentMethodCell
            cell.title.text = "Cash Only"
            return cell
        }
    }
    
    
}

