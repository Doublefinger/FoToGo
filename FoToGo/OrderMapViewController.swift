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

class OrderMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var ref: FIRDatabaseReference!
    var tasks: [FIRDataSnapshot]! = []
    fileprivate var _refHandle: FIRDatabaseHandle!
    let locationManager = CLLocationManager()
    
    func getLocationUpdate() {
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestAlwaysAuthorization()
            getLocationUpdate()
        }
        configureDatabase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        _refHandle = self.ref.child("tasks").observe(.childAdded, with: { [weak self] (snapshot) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tasks.append(snapshot)
            self?.drawTask(taskData: snapshot)
        })
    }
    
    func drawTask(taskData: FIRDataSnapshot) {
        let task = taskData.value as! NSDictionary
        let restLati = task[Constants.OrderFields.restaurantLatitude] as! NSNumber
        let restLong = task[Constants.OrderFields.restaurantLongitude] as! NSNumber
        let position = CLLocationCoordinate2D(latitude: restLati.doubleValue, longitude: restLong.doubleValue)
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.map  = mapView
    }
    
    deinit {
        self.ref.child("tasks").removeObserver(withHandle: _refHandle)
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
