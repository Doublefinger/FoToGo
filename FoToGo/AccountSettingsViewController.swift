//
//  AccountSettingsViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 23/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class AccountSettingsViewController: UIViewController {

    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var mobile: UILabel!
    
    @IBOutlet weak var homeButton: UIStackView!
    @IBOutlet weak var classButton: UIStackView!
    @IBOutlet weak var libraryButton: UIStackView!
    @IBOutlet weak var friendsProfile: UIStackView!
    
    @IBOutlet weak var homeAddress: UILabel!
    @IBOutlet weak var classAddress: UILabel!
    @IBOutlet weak var libraryAddress: UILabel!
    
    @IBOutlet weak var deleteHomeButton: UIButton!
    @IBOutlet weak var deleteClassButton: UIButton!
    @IBOutlet weak var deleteLibraryButton: UIButton!
    
    var autoCompleteController: GMSAutocompleteViewController!
    var ref = FIRDatabase.database().reference()

    enum addressModule {
        case home
        case classroom
        case library
    }
    
    var aModule: addressModule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.username.text = AppState.sharedInstance.displayName
        self.email.text = AppState.sharedInstance.email
        var mobileText = AppState.sharedInstance.mobile
        mobileText?.insert("-", at: (mobileText?.index((mobileText?.startIndex)!, offsetBy: 3))!)
        mobileText?.insert("-", at: (mobileText?.index((mobileText?.startIndex)!, offsetBy: 7))!)
        self.mobile.text = mobileText
        self.profileImage.image = AppState.sharedInstance.profileImage
        self.profileImage.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.presentEditAccountView(_:)))
        self.userInfoView.addGestureRecognizer(gesture)
        
        self.homeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addHome(_:))))
        self.classButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addClassroom(_:))))
        self.libraryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addLibrary(_:))))
        self.friendsProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addFriendProfile(_:))))
        
        if let home = AppState.sharedInstance.home {
            homeAddress.text = home.name
            deleteHomeButton.isHidden = false
        }
        
        if let classroom = AppState.sharedInstance.classroom {
            classAddress.text = classroom.name
            deleteClassButton.isHidden = false
        }
        
        if let library = AppState.sharedInstance.library {
            libraryAddress.text = library.name
            deleteLibraryButton.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.SignOut {
            Manager.sharedInstance.signOut()
        }
    }
    
    func presentEditAccountView(_ sender: UITapGestureRecognizer) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "editAccount") as! EditAccountViewController
        viewController.triggedBy = "AccountSettings"
        self.present(viewController, animated: true, completion: nil)
    }
    
    func addHome (_ sender: UITapGestureRecognizer) {
        autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        aModule = .home
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func addClassroom (_ sender: UITapGestureRecognizer) {
        autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        aModule = .classroom
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func addLibrary (_ sender: UITapGestureRecognizer) {
        autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        aModule = .library
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func addFriendProfile (_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func deleteHomeAddress(_ sender: Any) {
        let path = "users/" + AppState.sharedInstance.uid! + "/" + "homeAddress"
        self.ref.child(path).removeValue { (error, ref) in
            if error == nil {
                self.homeAddress.text = "Add Home"
                self.deleteHomeButton.isHidden = true
                AppState.sharedInstance.home = nil
            }
        }
    }
    
    @IBAction func deleteClassroomAddress(_ sender: Any) {
        let path = "users/" + AppState.sharedInstance.uid! + "/" + "classroomAddress"
        self.ref.child(path).removeValue { (error, ref) in
            if error == nil {
                self.classAddress.text = "Add Classroom"
                self.deleteClassButton.isHidden = true
                AppState.sharedInstance.classroom = nil
            }
        }
    }
    
    @IBAction func deleteLibraryAddress(_ sender: Any) {
        let path = "users/" + AppState.sharedInstance.uid! + "/" + "libraryAddress"
        self.ref.child(path).removeValue { (error, ref) in
            if error == nil {
                self.libraryAddress.text = "Add Library"
                self.deleteLibraryButton.isHidden = true
                AppState.sharedInstance.library = nil
            }
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

extension AccountSettingsViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        var address = [String: Any]()
        address["name"] = place.name
        address["latitude"] = place.coordinate.latitude
        address["longitude"] = place.coordinate.longitude
        
        switch aModule! {
        case .home:
            homeAddress.text = place.name
            let path = "users/" + AppState.sharedInstance.uid! + "/homeAddress"
            self.ref.child(path).setValue(address) { (error, ref) in
                if error == nil {
                    self.deleteHomeButton.isHidden = false
                    AppState.sharedInstance.home = Address(name: place.name, location: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                }
            }
            break
        case .classroom:
            classAddress.text = place.name
            let path = "users/" + AppState.sharedInstance.uid! + "/classroomAddress"
            self.ref.child(path).setValue(address) { (error, ref) in
                if error == nil {
                    self.deleteClassButton.isHidden = false
                     AppState.sharedInstance.classroom = Address(name: place.name, location: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                }
            }
            break
        default:
            libraryAddress.text = place.name
            let path = "users/" + AppState.sharedInstance.uid! + "/libraryAddress"
            self.ref.child(path).setValue(address) { (error, ref) in
                if error == nil {
                    self.deleteLibraryButton.isHidden = false
                     AppState.sharedInstance.library = Address(name: place.name, location: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                }
            }
            break
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {}
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
