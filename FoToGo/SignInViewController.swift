//
//  SignInViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 19/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    var responseAlert: UIAlertController!
    var emailText: String!
    var message: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.message = ""
        email.text = emailText ?? ""
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.title = "Sign In"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ResetPasswordViewController
        controller.emailText = email.text
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        showAlert()
        if !Helper.isValidSchoolEmail(text: email.text!) {
            emailError.isHidden = false
            self.finish()
            return
        } else {
            emailError.isHidden = true
        }
        
        if password.text == "" || password.text!.characters.count < 6 {
            passwordError.isHidden = false
            self.finish()
            return
        } else {
            passwordError.isHidden = true
        }
        Manager.sharedInstance.signIn(email.text!, password.text!, viewController: self)
    }
    
    func finish(){
        if message == Constants.Messages.success {
            self.responseAlert.dismiss(animated: true, completion: { 
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "mainPage")
                self.present(viewController!, animated: true, completion: nil)
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
        responseAlert = UIAlertController(title: "", message: "Verifying", preferredStyle: UIAlertControllerStyle.alert)
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
