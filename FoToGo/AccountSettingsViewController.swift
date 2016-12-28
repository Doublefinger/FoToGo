//
//  AccountSettingsViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 23/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController {

    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var mobile: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.username.text = AppState.sharedInstance.displayName
        self.email.text = AppState.sharedInstance.email
        self.mobile.text = AppState.sharedInstance.mobile
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.presentEditAccountView(_:)))
        self.userInfoView.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(_ sender: Any) {
        
    }
    
    func presentEditAccountView(_ sender: UITapGestureRecognizer) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "editAccount")
        self.present(viewController!, animated: true, completion: nil)
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
