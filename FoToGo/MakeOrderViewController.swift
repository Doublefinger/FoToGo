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

    var postTaskAlert: UIAlertController!

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editPlaceA(_ sender: Any) {
        self.present(startAutocompleteController, animated: true, completion: nil)
    }

    @IBAction func editPlaceB(_ sender: Any) {
        self.present(endAutocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func post(_ sender: Any) {
        guard let startText = self.start.text else {
            return
        }
        
        guard let endText = self.end.text else {
            return
        }
        
        if startText == "" || endText == "" {
            return
        }
        
        //generate task info
        postTaskAlert = UIAlertController(title: "Confirmation", message: startText + " - " + endText, preferredStyle: .alert)
        postTaskAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.sendTask(start: startText, end: endText)
        }))
        
        postTaskAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            self.postTaskAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(postTaskAlert, animated: true, completion: nil)
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
        tData[Constants.OrderFields.madeTime] = Helper.convertDate(NSDate())
        tData[Constants.OrderFields.restaurantId] = placeA.placeID
        tData[Constants.OrderFields.checked] = "no"
        self.ref.child("tasks").childByAutoId().setValue(tData, withCompletionBlock: { (error, ref) -> Void in
            self.start.text = ""
            self.end.text = ""
            self.mapView.clear()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = segue.destination
//        controller.navigationController?.setNavigationBarHidden(false, animated: false)
//        controller.navigationItem.leftItemsSupplementBackButton = true
//        if let identifier = segue.identifier {
//            switch identifier {
//            case Constants.Segues.ShowOrderContent:
//                controller.navigationItem.title = "Order Item"
//                break
//            case Constants.Segues.ShowEstimateCost:
//                controller.navigationItem.title = "Estimate Cost"
//                break
//            case Constants.Segues.ShowExpectedTime:
//                controller.navigationItem.title = "Expected Deliver Time"
//                break
//            default:
//                break
//            }
//        }
        
//            let orderInfo = self.orderInfos[indexPath.row]
//            let controller = (segue.destination as! OrderDetailViewController)
//            controller.detailItem = orderInfo
//            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//            controller.navigationItem.leftItemsSupplementBackButton = true
//            controller.navigationItem.title = orderInfo.restaurantName + " - " + orderInfo.destinationName
        
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

extension MakeOrderViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if viewController == startAutocompleteController {
            self.start.text = place.name
            markerA = GMSMarker()
            markerA.position = place.coordinate
            markerA.title = place.name
            markerA.icon = UIImage(named: "Restaurant Pickup-30")
            markerA.map = mapView
            placeA = place
        } else {
            markerB = GMSMarker()
            markerB.position = place.coordinate
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = UIImage(named: "More Than-30")
        switch indexPath.row {
        case 0:
            let cell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: "orderDetailCell") as! OrderDetailCell
            cell.title.text = "Order Detail"
            cell.detail.text = "Roast Beef Sandwiches"
            cell.goDetail.image = image
            return cell
        case 1:
            let cell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: "estimateCostCell") as! EstimateCostCell
            cell.title.text = "Estimate Cost"
            cell.detail.text = "10.00"
            cell.goDetail.image = image
            return cell
        case 3:
            let cell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: "expectedTimeCell") as! ExpectedTimeCell
            cell.title.text = "Expected Time"
            cell.detail.text = "Hello"
            cell.goDetail.image = image
            return cell
        default:
            let cell = self.orderDetailTableView.dequeueReusableCell(withIdentifier: "paymentMethodCell") as! PaymentMethodCell
            cell.title.text = "Cash Only"
            return cell
        }
    }
}

