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
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.profileImageView.image = AppState.sharedInstance.profileImage
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        self.profileImageView.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.presentEditAccountView(_:)))
        self.profileImageView.addGestureRecognizer(gesture)
        self.profileImageView.isUserInteractionEnabled = true
        username.text = AppState.sharedInstance.displayName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        slideMenuController()?.closeLeftNonAnimation()
    }
    
    func presentEditAccountView(_ sender: UITapGestureRecognizer) {
        slideMenuController()?.closeLeftNonAnimation()
        let viewController = storyboard?.instantiateViewController(withIdentifier: "editAccount") as! EditAccountViewController
        viewController.triggedBy = "mainPage"
        self.present(viewController, animated: true, completion: nil)
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
