//
//  MainPageViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 08/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class OrderMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
