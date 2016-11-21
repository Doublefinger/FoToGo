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
    
    var emailText: String!
    var message: String!
    var responseAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.message = ""
        email.text = emailText ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if email.text == "" {
            return
        }
        
        let controller = segue.destination as! SignInViewController
        controller.emailText = email.text
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toSignIn" {
            return true
        }
        
        if message == Constants.Messages.success {
            return true
        }
        
        if email.text == "" {
            return false
        }
        self.showAlert()
        Manager.sharedInstance.resetPassword(email.text!, viewController: self)
        return false
    }
    
    func finish(){
        if message == Constants.Messages.success {
            self.responseAlert.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "toSignIn", sender: self)
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
        responseAlert = UIAlertController(title: "", message: "Submitting", preferredStyle: UIAlertControllerStyle.alert)
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
