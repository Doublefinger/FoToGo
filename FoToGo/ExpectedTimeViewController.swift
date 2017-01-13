//
//  ExpectedTimeViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 10/01/2017.
//  Copyright © 2017 Doublefinger. All rights reserved.
//

import UIKit

class ExpectedTimeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var expectedTimePicker: UIDatePicker!
    var expectedTime: NSDate!
    
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
            controller.expectedTime = expectedTimePicker.date as NSDate
        } else {
            let minDate = Date()
            let maxDate = Calendar.current.date(byAdding: .day, value: 1, to: minDate)
            expectedTimePicker.minimumDate = minDate
            expectedTimePicker.maximumDate = maxDate
            expectedTimePicker.setDate(expectedTime as Date, animated: true)
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
