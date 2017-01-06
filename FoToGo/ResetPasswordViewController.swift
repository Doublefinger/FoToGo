//
//  ResetPasswordViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 19/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var reset: UIButton!
    
    var emailText: String!
    var message: String!
    var responseAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.title = "Reset Password"
        
        self.message = ""
        email.text = emailText ?? ""
        self.reset.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPass(_ sender: Any) {
        self.showAlert()
        if !Helper.isValidSchoolEmail(text: email.text!) {
            message = "Please enter a valid school email"
            self.finish()
            return
        }
        Manager.sharedInstance.resetPassword(email.text!, viewController: self)
    }
    
    func finish(){
        if message == Constants.Messages.success {
            self.responseAlert.dismiss(animated: true, completion: {
                self.reset.isEnabled = false
            })
        } else {
            //show warning
            responseAlert.message = message
            responseAlert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in
                self.responseAlert.dismiss(animated: true, completion: nil)
            }))
        }
    }
    
    func showAlert() {
        responseAlert = UIAlertController(title: "", message: "Sending", preferredStyle: UIAlertControllerStyle.alert)
        self.present(responseAlert, animated: true, completion: nil)
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
