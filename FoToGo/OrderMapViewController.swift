//
//  MainPageViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 08/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GoogleMaps
import GooglePlaces

class OrderMapViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    var markers = [GMSMarker]()
    var prevRestMarker: GMSMarker!
    var acceptTaskAlert: UIAlertController!
    
    var ref: FIRDatabaseReference!
    var waitingTasks: FIRDatabaseQuery!
    var tasks: [FIRDataSnapshot]! = []
    fileprivate var _refAddHandle, _refUpdateHandle: FIRDatabaseHandle!
    let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestAlwaysAuthorization()
            getLocationUpdate()
        }
        configureDatabase()
        configureAlert()
        prevRestMarker = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if (!(marker.userData is String)) {
            if self.prevRestMarker?.map == nil {
                displayRestaurantMarker(marker)
            } else {
                if marker.userData as? GMSMarker != self.prevRestMarker {
                    self.prevRestMarker.map = nil
                    displayRestaurantMarker(marker)
                }
            }
        }
        return false;
    }
 
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        if (marker.userData is String) {
//            taskId = marker.userData as! String!
            self.present(acceptTaskAlert, animated: true, completion: nil)
        }
    }
    
    func configureAlert() {
        acceptTaskAlert = UIAlertController(title: "Confirmation", message: "Do you want to pick this order?", preferredStyle: UIAlertControllerStyle.alert)
        acceptTaskAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.orderPicked()
        }))
        acceptTaskAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            self.acceptTaskAlert.dismiss(animated: true, completion: nil)
        }))
    }
    
    func orderPicked(){
        let path = "tasks/" + (mapView.selectedMarker?.userData as! String) + "/"
        self.ref.child(path + Constants.OrderFields.state).setValue("pick")
        self.ref.child(path + Constants.OrderFields.pickedBy).setValue(AppState.sharedInstance.uid)
    }
    
    func displayRestaurantMarker(_ marker: GMSMarker) {
        let restMarker = marker.userData as! GMSMarker
        restMarker.map = mapView
        self.prevRestMarker = restMarker
    }

    func displayTask(_ task: NSDictionary, taskId: String) {
        let restName = task[Constants.OrderFields.restaurantName] as! NSString
        let destName = task[Constants.OrderFields.destinationName] as! NSString
        let restLati = task[Constants.OrderFields.restaurantLatitude] as! NSNumber
        let restLong = task[Constants.OrderFields.restaurantLongitude] as! NSNumber
        let destLati = task[Constants.OrderFields.destinationLatitude] as! NSNumber
        let destLong = task[Constants.OrderFields.destinationLongitude] as! NSNumber
        
        let restMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: restLati.doubleValue, longitude: restLong.doubleValue))
        restMarker.icon = UIImage(named: "Restaurant Pickup-30")
        restMarker.title = restName as String
        restMarker.snippet = "Long press the info window to pick this order"
        restMarker.map = nil
        restMarker.userData = taskId
        
        let destMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: destLati.doubleValue, longitude: destLong.doubleValue))
        destMarker.icon = UIImage(named: "FF-30")
        destMarker.title = destName as String
        destMarker.snippet = "Type the restaurant marker to pick an order"
        destMarker.userData = restMarker
        destMarker.map = mapView
        markers.append(destMarker)
    }
    
    func removeTask(_ taskId: String) {
        var index = -1
        for marker in markers {
            let restMarker = marker.userData as! GMSMarker
            if (restMarker.userData as! String) == taskId {
                restMarker.map = nil
                marker.map = nil
                index = markers.index(of: marker)!
            }
        }
        if index >= 0 {
            markers.remove(at: index)
        }
    }
    
    func getLocationUpdate() {
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func configureDatabase() {
        self.ref = FIRDatabase.database().reference()
        self.waitingTasks = self.ref.child("tasks").queryOrdered(byChild: Constants.OrderFields.state).queryEqual(toValue: Constants.OrderStates.wait)
        
        _refAddHandle = waitingTasks.observe(.childAdded, with: { [weak self] (snapshot) in
            guard let strongSelf = self else {
                return
            }
//            strongSelf.tasks.append(snapshot)
            print("enter map add")
            let task = snapshot.value as! NSDictionary
            strongSelf.displayTask(task, taskId: snapshot.key)
        })
        _refUpdateHandle = self.ref.child("tasks").observe(.childChanged, with: { [weak self] (snapshot) in
            guard let strongSelf = self else {
                return
            }
            print("enter map change")
            
            let task = snapshot.value as! NSDictionary
            let state = task[Constants.OrderFields.state] as! String
            if state == Constants.OrderStates.pick {
                strongSelf.removeTask(snapshot.key)
            }
            
            if state == Constants.OrderStates.complete && ((task[Constants.OrderFields.account] as! String) == AppState.sharedInstance.uid) || ((task[Constants.OrderFields.pickedBy] as! String) == AppState.sharedInstance.uid) {
                print("enter notification")
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationKeys.PickOrder), object: snapshot.key)
            }

        })
    
    }
    
    deinit {
        waitingTasks.removeObserver(withHandle: _refAddHandle)
        waitingTasks.removeObserver(withHandle: _refUpdateHandle)
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


extension OrderMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.getLocationUpdate()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            mapView.camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 15)
            self.locationManager.stopUpdatingLocation()
        }
    }
}
