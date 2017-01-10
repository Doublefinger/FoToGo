//
//  RegisterationNavigationViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 05/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit
import Firebase

class NavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
