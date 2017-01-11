//
//  EstimateCostViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 10/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit

class EstimateCostViewController: UIViewController, UINavigationControllerDelegate{

    @IBOutlet weak var estimateCost: UITextField!
    var estimateCostText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.leftItemsSupplementBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? MakeOrderViewController {
            controller.estimateCost = estimateCost.text!
        } else {
            estimateCost.text = estimateCostText
        }
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
