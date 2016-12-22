//
//  LeftMenuViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 21/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        print(self.profileImageView.frame.size.width)
        print(self.profileImageView.frame.size.height)
        self.profileImageView.clipsToBounds = true
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
