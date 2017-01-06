//
//  PaymentInfoViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 07/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class PaymentInfoViewController: UIViewController {
    var userInfo: UserInfo!
    var message: String!
    var responseAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.message = ""
        // Do any additional setup after loading the view.
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.title = "Payment"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEmailCheck" {
            let controller = segue.destination as! FinishRegistrationViewController
            controller.emailAddress = userInfo.email
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toEmailCheck" {
            if message == Constants.Messages.success {
                return true
            }
            self.showAlert()
            Manager.sharedInstance.register(userInfo: userInfo, viewController: self)
            return false
        }
        return true
    }
    
    func finish(){
        if message == Constants.Messages.success {
            self.responseAlert.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "toEmailCheck", sender: self)
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
