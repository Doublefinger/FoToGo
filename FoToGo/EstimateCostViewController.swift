//
//  EstimateCostViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 10/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit

class EstimateCostViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var estimateCost: UITextField!
    var estimateCostText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
        self.navigationItem.leftItemsSupplementBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? MakeOrderViewController {
            if estimateCost.text == "" {
                controller.estimateCost = "0.00"
            } else {
                controller.estimateCost = String(format: "%.2f", Double(estimateCost.text!)!)
            }
            controller.orderDetailTableView.reloadData()
        } else {
            estimateCost.text = estimateCostText
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0 {
            return true
        }
        
        let currentText = textField.text ?? "";
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if Helper.isNumericWithDot(text: prospectiveText) && prospectiveText.characters.count <= 6 {
            guard let result = Double(prospectiveText) else {
                return false
            }
            return result > 0.0
        }
        
        return false
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
