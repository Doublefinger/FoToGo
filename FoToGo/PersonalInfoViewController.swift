//
//  RegisterViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 07/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit


class PersonalInfoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var majorPicker: UIPickerView!
    
    @IBOutlet weak var firstNameError: UILabel!
    @IBOutlet weak var lastNameError: UILabel!
    @IBOutlet weak var mobileError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    var major = [String]()
    var userInfo: UserInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.title = "Register"
        major = ["Freshman", "Sophomore", "Junior", "Senior", "Postgraduate"]
//        if (userInfo) != nil {
//            firstName.text = userInfo.firstName
//            lastName.text = userInfo.lastName
//            var mobileText = userInfo.mobile
//            mobileText.insert("-", at: (mobileText.index((mobileText.startIndex), offsetBy: 3)))
//            mobileText.insert("-", at: (mobileText.index((mobileText.startIndex), offsetBy: 7)))
//            mobile.text = mobileText
//            email.text = userInfo.email
//            password.text = userInfo.password
//            var row = 0
//            for index in 0...4 {
//                if major[index] == userInfo.major {
//                    row = index
//                    break
//                }
//            }
//            majorPicker.selectRow(row, inComponent: 0, animated: false)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! PaymentInfoViewController
        controller.userInfo = userInfo
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //check user input
        var valid : Bool = true
        if firstName.text == "" {
            valid = false
            firstNameError.isHidden = false
        } else {
            firstNameError.isHidden = true
        }
        
        if lastName.text == "" {
            valid = false
            lastNameError.isHidden = false
        } else {
            lastNameError.isHidden = true
        }
        
        if password.text == "" || password.text!.characters.count < 6 {
            valid = false
            passwordError.isHidden = false
        } else {
            passwordError.isHidden = true
        }
        
        var mobileText = mobile.text!

        if !Helper.isPhoneNumber(text: mobileText) {
            valid = false
            mobileError.isHidden = false
        } else {
            mobileError.isHidden = true
        }
        
        if email.text == "" || !Helper.isValidSchoolEmail(text: email.text!) {
            valid = false
            emailError.isHidden = false
        } else {
            emailError.isHidden = true
        }

        if !valid {
            return valid
        }
        
        let majorIndex = majorPicker.selectedRow(inComponent: 0)
        mobileText.remove(at: mobileText.index(mobileText.startIndex, offsetBy: 3))
        mobileText.remove(at: mobileText.index(mobileText.startIndex, offsetBy: 6))
        
        userInfo = UserInfo.init(firstName: firstName.text!, lastName: lastName.text!, mobile: mobileText, email: email.text!, major: major[majorIndex], password: password.text!)
        
        return valid
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //check while user is typing
        if string.characters.count == 0 {
            return true
        }
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        switch textField {
        case firstName,
             lastName:
            return Helper.isAlpha(text: prospectiveText) && prospectiveText.characters.count <= 20
        case password:
            return prospectiveText.characters.count <= 20
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return major.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return major[row]
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
