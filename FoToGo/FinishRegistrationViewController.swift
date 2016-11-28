//
//  FinishRegistrationViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 28/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class FinishRegistrationViewController: UIViewController {
    var emailAddress: String!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SignInViewController
        controller.emailText = emailAddress!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
