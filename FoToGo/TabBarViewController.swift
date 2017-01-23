//
//  TabBarViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 06/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import SlideMenuControllerSwift

class TabBarViewController: UITabBarController{

    var count = 0
    var ref: FIRDatabaseReference!
    var gesture: UITapGestureRecognizer!
    
    var trackOrderMadeBy, trackOrderPickedBy: FIRDatabaseQuery!
    fileprivate var _refTrackOrderMadeHandle, _refTrackOrderPickedHandle: FIRDatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppState.sharedInstance.uncheckedOrders = [String]()
        // Do any additional setup after loading the view.
        self.configureDatabase()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarViewController.removeBadge), name: Notification.Name(rawValue: Constants.NotificationKeys.RemoveBadge), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func increaseBadgeCount(){
        self.count = self.count + 1
        self.tabBar.items?[2].badgeValue = String(self.count)
    }
    
    func removeBadge() {
        if self.count == 0 {
            return
        }
        
        for taskId in AppState.sharedInstance.uncheckedOrders! {
            let path = "tasks/" + taskId + "/"
            self.ref.child(path + Constants.OrderFields.checked).setValue("yes")
        }
        
        self.count = 0
        
        self.tabBar.items?[2].badgeValue = nil
    }
    
    func configureDatabase() {
        self.ref = FIRDatabase.database().reference()
        //personal orders
        self.trackOrderMadeBy = self.ref.child("tasks").queryOrdered(byChild: Constants.OrderFields.account).queryEqual(toValue: AppState.sharedInstance.uid)
        _refTrackOrderMadeHandle = self.trackOrderMadeBy.observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            AppState.sharedInstance.inProcessOrders.append(snapshot)
            let task = snapshot.value as! NSDictionary
            let checked = task[Constants.OrderFields.checked] as! String
            if checked == "no" {
                AppState.sharedInstance.uncheckedOrders?.append(snapshot.key)
                strongSelf.increaseBadgeCount()
            }
        })
        
        self.trackOrderPickedBy = self.ref.child("tasks").queryOrdered(byChild: Constants.OrderFields.pickedBy).queryEqual(toValue: AppState.sharedInstance.uid)
        _refTrackOrderPickedHandle = self.trackOrderPickedBy.observe(.childAdded, with: { (snapshot) -> Void in
            AppState.sharedInstance.inProcessOrders.append(snapshot)
        })
    }
    
    deinit {
        if let ref = self.trackOrderMadeBy {
            ref.removeObserver(withHandle: _refTrackOrderMadeHandle)
        }
        
        if let ref = self.trackOrderPickedBy {
            ref.removeObserver(withHandle: _refTrackOrderPickedHandle)
        }
    }

}
