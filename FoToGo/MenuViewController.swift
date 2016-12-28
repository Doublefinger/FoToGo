//
//  LeftMenuControllerViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 21/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MenuViewController: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SlideMenuOptions.leftViewWidth = (self.mainViewController?.view.frame.size.width)! * 0.75
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") {
            self.mainViewController = controller
        }
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenu") {
            self.leftViewController = controller
        }
        
        super.awakeFromNib()
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
