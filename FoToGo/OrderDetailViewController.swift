//
//  OrderDetailViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 02/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import Firebase

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var destName: UILabel!
    @IBOutlet weak var theOtherName: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var readyToGo: UIButton!
    @IBOutlet weak var arrived: UIButton!
    @IBOutlet weak var delivered: UIButton!
    @IBOutlet weak var distance: UIButton!
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var destImage: UIImageView!
    @IBOutlet weak var theOtherImage: UIImageView!
    
    var ref: FIRDatabaseReference!

    var detailItem: OrderInfo?  {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail = self.detailItem {
            if let label = self.restName {
                label.text = detail.restaurantName
            }
            
            if let label = self.destName {
                label.text = detail.destinationName
            }

            if let label = self.orderState {
                label.text = detail.state
            }

//            if detail.account == AppState.sharedInstance.uid {
//                if let label = self.theOtherName {
//                    label.text = AppState.sharedInstance.displayName!
//                    self.configureDatabase(queryId: detail.pickedBy);
//                }
//            } else {
//                if let label = self.theOtherName {
//                    label.text = label.text! + " " + AppState.sharedInstance.displayName!
//                    self.configureDatabase(queryId: detail.account);
//                }
//            }
            
            if let imageView = self.restImage {
                imageView.image = detail.photo
                imageView.layer.cornerRadius = imageView.frame.size.height/2
                imageView.clipsToBounds = true
            }
        }
    }
    
    func configureDatabase(queryId: String) {
        self.ref = FIRDatabase.database().reference()
        
//        self.ref.child("users").queryOrderedByKey().queryEqual(toValue: queryId).observeSingleEvent(of: .childAdded, with: {[weak self] (snapshot) -> Void in
//            guard let strongSelf = self else {
//                return
//            }
//            let user = snapshot.value as! NSDictionary
//            strongSelf.mobile.text = strongSelf.mobile.text! + (user[Constants.UserFields.mobile] as! String)
//            if strongSelf.detailItem?.account == AppState.sharedInstance.uid {
//                strongSelf.pickedBy.text = strongSelf.pickedBy.text! + (user[Constants.UserFields.name] as! String)
//            } else {
//                strongSelf.requestedBy.text = strongSelf.requestedBy.text! + (user[Constants.UserFields.name] as! String)
//            }
//        })

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
