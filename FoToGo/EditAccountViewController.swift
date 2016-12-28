//
//  EditAccountViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 26/12/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var message: String!
    var responseAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.message = ""
        self.saveButton.isEnabled = false
        self.saveButton.backgroundColor = UIColor.lightGray
        
        let fullName = AppState.sharedInstance.displayName?.characters.split(separator: " ").map(String.init)
        self.firstName.text = fullName?[0]
        self.lastName.text = fullName?[1]
        self.email.text = AppState.sharedInstance.email
        var mobileText = AppState.sharedInstance.mobile
        mobileText?.insert("-", at: (mobileText?.index((mobileText?.startIndex)!, offsetBy: 3))!)
        mobileText?.insert("-", at: (mobileText?.index((mobileText?.startIndex)!, offsetBy: 7))!)
        self.mobile.text = mobileText
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.addPhoto(_:)))
        self.userProfileImage.isUserInteractionEnabled = true
        self.userProfileImage.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.saveButton.isEnabled = true
        self.saveButton.backgroundColor = UIColor.darkGray
        if string.characters.count == 0 {
            return true
        }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        switch textField {
        case firstName, lastName:
             return Helper.isAlpha(text: prospectiveText) && prospectiveText.characters.count <= 20
        case mobile:
            if prospectiveText.characters.count > 12 {
               return false
            }
            if currentText.characters.count == 3 || currentText.characters.count == 7 {
                textField.text = currentText + "-"
            }
            return true
        default:
            return true
        }
    }
    
    func addPhoto(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        var valid : Bool = true
        guard let firstNameText = firstName.text else {
            valid = false
            Helper.showErrorIndicator(textField: firstName)
            return
        }
        Helper.removeErrorIndicator(textField: firstName)

        guard let lastNameText = lastName.text else {
            valid = false
            Helper.showErrorIndicator(textField: lastName)
            return
        }
        Helper.removeErrorIndicator(textField: lastName)
        
        guard let emailText = email.text else {
            valid = false
            Helper.showErrorIndicator(textField: email)
            return
        }
        
        if !Helper.isValidSchoolEmail(text: emailText) {
            valid = false
            Helper.showErrorIndicator(textField: email)
        } else {
            Helper.removeErrorIndicator(textField: email)
        }

        guard var mobileText = mobile.text else {
            valid = false
            Helper.showErrorIndicator(textField: mobile)
            return
        }
        
        if !Helper.isPhoneNumber(text: mobile.text!) {
            valid = false
            Helper.showErrorIndicator(textField: mobile)
        } else {
            Helper.removeErrorIndicator(textField: mobile)
        }
        
        if !valid {
            return
        }

        mobileText.remove(at: mobileText.index(mobileText.startIndex, offsetBy: 3))
        mobileText.remove(at: mobileText.index(mobileText.startIndex, offsetBy: 6))
        if firstNameText + " " + lastNameText == AppState.sharedInstance.displayName
            && mobileText == AppState.sharedInstance.mobile && emailText == AppState.sharedInstance.email {
            return
        }
        
        print("ready")
        let userInfo = UserInfo(firstName: firstNameText, lastName: lastNameText, mobile: mobileText, email: emailText, major: "", password: "")
//        Manager.sharedInstance.updateUserInfo(userInfo, viewController: self)
    }
    
    func finish() {
        if message == Constants.Messages.success {
            
        }
    }
    
    func showAlert() {
        responseAlert = UIAlertController(title: "", message: "Submitting", preferredStyle: UIAlertControllerStyle.alert)
        self.present(responseAlert, animated: true, completion: nil)
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
