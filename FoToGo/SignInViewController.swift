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
    
    var responseAlert: UIAlertController!
    var emailText: String!
    var message: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.message = ""
        email.text = emailText ?? ""
        // Do any additional setup after loading the view.
        //需要给forgot password按钮添加下划线
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReset" {
            if email.text == "" {
                return
            }
            let controller = segue.destination as! ResetPasswordViewController
            controller.emailText = email.text
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toMain" {
            if self.message == Constants.Messages.success {
                print("toMain")

                return true
            }
            if email.text == "" || !Helper.isValidSchoolEmail(text: email.text!) {
                Helper.showErrorIndicator(textField: email)
                return false
            } else {
                Helper.removeErrorIndicator(textField: email)
            }

            if password.text == "" || password.text!.characters.count < 6 {
                Helper.showErrorIndicator(textField: password)
                return false
            } else {
                Helper.removeErrorIndicator(textField: password)
            }
            self.showAlert()
            Manager.sharedInstance.signIn(email.text!, password.text!, viewController: self)
            return false
        }
        
        return true
    }
    
    func finish(){
        if message == Constants.Messages.success {
            self.responseAlert.dismiss(animated: true, completion: { 
                self.performSegue(withIdentifier: "toMain", sender: self)
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
