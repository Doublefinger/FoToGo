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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppState.sharedInstance.orderInfos = [OrderInfo]()
        AppState.sharedInstance.uncheckedOrders = [String]()
        // Do any additional setup after loading the view.
        self.ref = FIRDatabase.database().reference()

        NotificationCenter.default.addObserver(self, selector: #selector(TabBarViewController.increaseBadgeCount), name: Notification.Name(rawValue: Constants.NotificationKeys.IncreaseBadge), object: nil)
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
//        print("delete badge")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
