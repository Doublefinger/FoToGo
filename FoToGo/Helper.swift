//
//  Utility.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 07/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//

import Foundation
import UIKit

public class Helper{
    
    static func isNumeric(text: String) -> Bool {
        let numbers = NSCharacterSet(charactersIn: "0123456789")
        if text.rangeOfCharacter(from: numbers.inverted) != nil {
            return false
        }
        return true
    }
    
    static func isAlpha(text: String) -> Bool {
        let letters = NSCharacterSet.letters
        if text.rangeOfCharacter(from: letters.inverted) != nil {
            return false
        }
        return true
    }
    
    static func isPartPhoneNumber(text: String) -> Bool {
        let numbers = NSCharacterSet(charactersIn: "0123456789")
        if text.rangeOfCharacter(from: numbers.inverted) != nil {
            return false
        }
        return true
    }
    
    static func isPhoneNumber(text: String) -> Bool {
        let phoneRegEx = "[0-9]{3}-[0-9]{3}-[0-9]{4}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: text)
    }
    
    static func isValidSchoolEmail(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.edu"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    static func showErrorIndicator(textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor.red.cgColor
    }
    
    static func removeErrorIndicator(textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
    static func convertDate(_ date: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        return formatter.string(from: date as Date)
    }
    
    static func displayDateInLocal(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        let date = formatter.date(from: string)
        formatter.timeZone = NSTimeZone.local
        return formatter.string(from: date!)
    }
}
