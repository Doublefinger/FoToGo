//
//  OrderDetailViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 02/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var destName: UILabel!
    @IBOutlet weak var requestedBy: UILabel!
    @IBOutlet weak var pickedBy: UILabel!
    @IBOutlet weak var state: UILabel!
    
    
    var detailItem: OrderInfo?  {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail = self.detailItem {
            print(detail.restaurantName)
            if let label = self.restName {
                label.text = label.text! + "" + detail.restaurantName
            }
            
            if let label = self.destName {
                label.text = label.text! + detail.destinationName
            }

            if let label = self.state {
                label.text = label.text! + detail.state
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureView()
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
