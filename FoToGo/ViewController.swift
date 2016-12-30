//
//  ViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 06/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FIRAuth.auth()?.currentUser != nil {
            let user = FIRAuth.auth()?.currentUser
            AppState.sharedInstance.uid = user?.uid
            Manager.sharedInstance.retrieveUserInfo()
            AppState.sharedInstance.displayName = user?.displayName
            AppState.sharedInstance.email = user?.email
            AppState.sharedInstance.signedIn = true
            if let url = user?.photoURL {
                FIRStorage.storage().reference(forURL: url.absoluteString).data(withMaxSize: INT64_MAX, completion: { (data, error) in
                    if error != nil {
                        AppState.sharedInstance.profileImage = UIImage(named: "user_default")
                    } else {
                        AppState.sharedInstance.profileImage = UIImage(data: data!)
                    }
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "mainPage")
                    self.present(viewController!, animated: true, completion: nil)
                })
            }
        }
    }
}

