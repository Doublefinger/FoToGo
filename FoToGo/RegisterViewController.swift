//
//  RegisterViewController.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 07/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile1: UITextField!
    @IBOutlet weak var mobile2: UITextField!
    @IBOutlet weak var mobile3: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var majorPicker: UIPickerView!
    
    var major = [String]()
    var userInfo: UserInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        major = ["Freshman", "Sophomore", "Junior", "Senior", "Postgraduate"]
        if (userInfo) != nil {
            firstName.text = userInfo.firstName
            lastName.text = userInfo.lastName
            let index1 = userInfo.mobile.index(userInfo.mobile.startIndex, offsetBy: 3)
            mobile1.text = userInfo.mobile.substring(to: index1)
            let index2 = userInfo.mobile.index(userInfo.mobile.startIndex, offsetBy: 6)
            mobile2.text = userInfo.mobile.substring(with: index1..<index2)
            mobile3.text = userInfo.mobile.substring(from: index2)
            email.text = userInfo.email
            password.text = userInfo.password
            var row = 0
            for index in 0...4 {
                if major[index] == userInfo.major {
                    row = index
                    break
                }
            }
            majorPicker.selectRow(row, inComponent: 0, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPayment" {
            let controller = segue.destination as! PaymentInfoViewController
            controller.userInfo = userInfo
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //check user input
        if identifier == "toStart" {
            return true
        }
        
        var valid : Bool = true
        if firstName.text == "" {
            valid = false
            Helper.showErrorIndicator(textField: firstName)
        } else {
            Helper.removeErrorIndicator(textField: firstName)
        }
        
        if lastName.text == "" {
            valid = false
            Helper.showErrorIndicator(textField: lastName)
        } else {
            Helper.removeErrorIndicator(textField: lastName)
        }
        
        if password.text == "" || password.text!.characters.count < 6 {
            valid = false
            Helper.showErrorIndicator(textField: password)
        } else {
            Helper.removeErrorIndicator(textField: password)
        }
        
        if mobile1.text == "" || mobile1.text!.characters.count != 3 {
            valid = false
            Helper.showErrorIndicator(textField: mobile1)
        } else {
            Helper.removeErrorIndicator(textField: mobile1)
        }
        
        if mobile2.text == "" || mobile2.text!.characters.count != 3 {
            valid = false
            Helper.showErrorIndicator(textField: mobile2)
        } else {
            Helper.removeErrorIndicator(textField: mobile2)
        }
        
        if mobile3.text == "" || mobile3.text!.characters.count != 4 {
            valid = false
            Helper.showErrorIndicator(textField: mobile3)
        } else {
            Helper.removeErrorIndicator(textField: mobile3)
        }
        
        if email.text == "" || !Helper.isValidSchoolEmail(text: email.text!) {
            valid = false
            Helper.showErrorIndicator(textField: email)
        } else {
            Helper.removeErrorIndicator(textField: email)
        }

        if !valid {
            return valid
        }
        
        //TODO also check if the email exists
        let majorIndex = majorPicker.selectedRow(inComponent: 0)
        if valid {
            userInfo = UserInfo.init(firstName: firstName.text!, lastName: lastName.text!, mobile: mobile1.text! + mobile2.text! + mobile3.text!, email: email.text!, major: major[majorIndex], password: password.text!)
        }
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
        case mobile1:
            return Helper.isPartPhoneNumber(text: prospectiveText) && prospectiveText.characters.count <= 3
        case mobile2:
            return Helper.isPartPhoneNumber(text: prospectiveText) && prospectiveText.characters.count <= 3
        case mobile3:
            return Helper.isPartPhoneNumber(text: prospectiveText) && prospectiveText.characters.count <= 4
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
