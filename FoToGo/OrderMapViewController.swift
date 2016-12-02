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
    var taskId: String!
    
    var ref: FIRDatabaseReference!
    var tasks: [FIRDataSnapshot]! = []
    fileprivate var _refAddHandle, _refUpdateHandle: FIRDatabaseHandle!
    var add_update_conflict = false
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

//            if self.prevRestMarker?.map == nil {
//                displayRestaurantMarker(marker)
//            } else {
//                self.prevRestMarker.map = nil
//                if marker.userData as? GMSMarker != self.prevRestMarker {
//                    displayRestaurantMarker(marker)
//                }
//            }
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
        acceptTaskAlert = UIAlertController(title: "Pick the Order", message: "Do you want to pick this order?", preferredStyle: UIAlertControllerStyle.alert)
        acceptTaskAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            self.acceptTaskAlert.dismiss(animated: true, completion: nil)
        }))
        acceptTaskAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.orderPicked()
        }))
    }
    
    func orderPicked(){
        let path = "tasks/" + (mapView.selectedMarker?.userData as! String) + "/state"
        self.ref.child(path).setValue("pick")
    }
    
    func displayRestaurantMarker(_ marker: GMSMarker) {
        let restMarker = marker.userData as! GMSMarker
        restMarker.map = mapView
        self.prevRestMarker = restMarker
    }

    func displayTask(taskData: FIRDataSnapshot) {
        let task = taskData.value as! NSDictionary
        let restName = task[Constants.OrderFields.restaurantName] as! NSString
        let destName = task[Constants.OrderFields.destinationName] as! NSString
        let restLati = task[Constants.OrderFields.restaurantLatitude] as! NSNumber
        let restLong = task[Constants.OrderFields.restaurantLongitude] as! NSNumber
        let destLati = task[Constants.OrderFields.destinationLatitude] as! NSNumber
        let destLong = task[Constants.OrderFields.destinationLongitude] as! NSNumber
        
        let restMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: restLati.doubleValue, longitude: restLong.doubleValue))
        restMarker.icon = UIImage(named: "Restaurant Pickup-30")
        restMarker.title = restName as String
        restMarker.map = nil
        restMarker.userData = taskData.key
        
        let destMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: destLati.doubleValue, longitude: destLong.doubleValue))
        destMarker.icon = UIImage(named: "FF-30")
        destMarker.title = destName as String
        destMarker.userData = restMarker
        destMarker.map = mapView
        markers.append(destMarker)
    }
    
    func removeTask(taskData: FIRDataSnapshot) {
        var index = -1
        for marker in markers {
            let restMarker = marker.userData as! GMSMarker
            if (restMarker.userData as! String) == taskData.key {
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
        ref = FIRDatabase.database().reference()
        let childRefQuery = self.ref.child("tasks").queryOrdered(byChild: Constants.OrderFields.state).queryEqual(toValue: "waiting")
        
        _refAddHandle = childRefQuery.observe(.childAdded, with: { [weak self] (snapshot) in
            guard self != nil else {
                return
            }
//            strongSelf.tasks.append(snapshot)
            print("addChild")
            self?.displayTask(taskData: snapshot)
        })
        
        _refUpdateHandle = self.ref.child("tasks").observe(.childChanged, with: { [weak self] (snapshot) in
            guard self != nil else {
                return
            }
            
            print("changeChild")
            self?.removeTask(taskData: snapshot)
        })
    }
    
    deinit {
        self.ref.child("tasks").removeObserver(withHandle: _refAddHandle)
        self.ref.child("tasks").removeObserver(withHandle: _refUpdateHandle)
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
