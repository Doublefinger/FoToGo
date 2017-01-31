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
import GeoFire

class OrderMapViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    
    var markers = [GMSMarker]()
    var prevRestMarker: GMSMarker!
    var acceptTaskAlert: UIAlertController!
    var messageAlert: UIAlertController!
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
//    var waitingTasks: FIRDatabaseQuery!
    var tasks: [FIRDataSnapshot]! = []
    let locationManager = CLLocationManager()
    var center: CLLocation! {
        didSet {
            configureDatabase()
        }
        
    }
    var query: GFCircleQuery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            getLocationUpdate()
        }
        configureDatabase()
        configureAlert()
        prevRestMarker = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Warning!", message: "GPS access is restricted. To view the order map, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Go to settings now", style: .default, handler: { (alert: UIAlertAction!) in
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signOut" {
            Manager.sharedInstance.signOut()
        }
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
        return false
    }
 
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        if (marker.userData is String) {
            self.present(acceptTaskAlert, animated: true, completion: nil)
        }
    }

    func orderPicked(){
        let taskId = mapView.selectedMarker?.userData as! String
        
        for snapshot in self.tasks {
            if taskId == snapshot.key {
                let task = snapshot.value as! NSDictionary
                if (task[Constants.OrderFields.account] as! String) == AppState.sharedInstance.uid {
                    self.present(messageAlert, animated: true, completion: nil)
                    print("cannot pick own task")
                    return
                }
                let path = "tasks/" + taskId + "/"
                self.ref.updateChildValues([path + Constants.OrderFields.state : Constants.OrderStates.pick, path + Constants.OrderFields.pickedBy: AppState.sharedInstance.uid as Any])
                let geoFire = GeoFire(firebaseRef: ref)
                geoFire?.removeKey(taskId)
                break
            }
        }
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
        
        if (task[Constants.OrderFields.account] as! NSString) as String == AppState.sharedInstance.uid {
            destMarker.icon = UIImage(named: "Empty Flag-30")
        } else {
            destMarker.icon = UIImage(named: "FF-30")
        }
        destMarker.title = destName as String
        destMarker.snippet = "Type the restaurant marker to pick an order"
        destMarker.userData = restMarker
        destMarker.map = mapView
        markers.append(destMarker)
    }
    
    func removeTask(_ taskId: String) {
        //虽然很丑，但很温柔
        var index = -1
        for marker in self.markers {
            let restMarker = marker.userData as! GMSMarker
            if (restMarker.userData as! String) == taskId {
                restMarker.map = nil
                marker.map = nil
                index = self.markers.index(of: marker)!
                break
            }
        }
        if index >= 0 {
            markers.remove(at: index)
            index = -1
            for snapshot in self.tasks {
                if taskId == snapshot.key {
                    index = self.tasks.index(of: snapshot)!
                    break
                }
            }
            
            if index >= 0 {
                self.tasks.remove(at: index)
            }
        }
    }
    
    func getLocationUpdate() {
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func configureAlert() {
        acceptTaskAlert = UIAlertController(title: "Confirmation", message: "Do you want to pick this order?", preferredStyle: UIAlertControllerStyle.alert)
        acceptTaskAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.orderPicked()
        }))
        acceptTaskAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            self.acceptTaskAlert.dismiss(animated: true, completion: nil)
        }))
        
        messageAlert = UIAlertController(title: "", message: "You cannot pick your own order!", preferredStyle: UIAlertControllerStyle.alert)
        messageAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            self.messageAlert.dismiss(animated: true, completion: nil)
        }))
    }
    
    func configureDatabase() {
        //waiting orders
        let geoFire = GeoFire(firebaseRef: ref)
        if query != nil {
            query.removeAllObservers()
        }
        
        query = (geoFire?.query(at: center, withRadius: 8.1))!
        
        query.observe(.keyEntered, with: { (key, location) in
            self.getTaskWithKey(key!)
        })

        query.observe(.keyExited) { (key, location) in
            self.removeTask(key!)
        }
    }
    
    func getTaskWithKey(_ key: String) {
        self.ref.child("tasks/"+key).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let strongSelf = self else {
                return
            }
            let task = snapshot.value as! NSDictionary
            strongSelf.tasks.append(snapshot)
            strongSelf.displayTask(task, taskId: snapshot.key)
        })
    }
    
    deinit {
        if let query = self.query {
            query.removeAllObservers()
        }
    }
}


extension OrderMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.getLocationUpdate()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            center = userLocation
            mapView.camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 15)
            self.locationManager.stopUpdatingLocation()
        }
    }
}
