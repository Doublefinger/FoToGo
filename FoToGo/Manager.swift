//
//  Manager.swift
//  FoToGo
//
//  Created by Shitianyu Pan on 15/11/2016.
//  Copyright © 2016 Doublefinger. All rights reserved.
//
//  This file has all functions which are used to send request to server
//

import Foundation
import UIKit
import Firebase

public class Manager{
    static let sharedInstance = Manager()
    var ref: FIRDatabaseReference!
    func register(userInfo: UserInfo, viewController: PaymentInfoViewController) {
        FIRAuth.auth()?.createUser(withEmail: userInfo.email, password: userInfo.password, completion: { (user, error) in
            if let error = error {
                viewController.message = error.localizedDescription
                viewController.finish()
                return
            }
//            firUser = user!
            self.registerInfo(user!, userInfo, viewController: viewController)
        })
    }
    
    func signIn(_ email: String, _ password: String, viewController: SignInViewController) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                viewController.message = error.localizedDescription
                viewController.finish()
                return
            }
//            firUser = user!
            if (user?.isEmailVerified)! {
                self.signedIn(user!)
                viewController.message = Constants.Messages.success
            } else {
                viewController.message = Constants.Messages.notVerified
            }
            viewController.finish()
        })
    }
    
    func resetPassword(_ email: String, viewController: ResetPasswordViewController){
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if let error = error {
                viewController.message = error.localizedDescription
                viewController.finish()
                return
            }
            viewController.message = Constants.Messages.success
            viewController.finish()
        })
    }
//    
//    func createDeliveryRequest(withData data: [String: String]) {
//        var mdata = data
//        mdata[Constants.OrderFields.account] = AppState.sharedInstance.email
//        //push data to Firebase Database
//        self.ref.child("tasks").childByAutoId().setValue(mdata)
//    }
//    
    private func registerInfo(_ user: FIRUser, _ userInfo: UserInfo, viewController: PaymentInfoViewController){
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = userInfo.firstName
        changeRequest.commitChanges { (error) in
            if let error = error {
                viewController.message = error.localizedDescription
                viewController.finish()
                return
            }
            self.sendEmailVerfication(user, viewController: viewController)
        }
    }
    
    private func signedIn(_ user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName
        AppState.sharedInstance.email = user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true
        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
    }
    
    private func sendEmailVerfication(_ user: FIRUser?, viewController: PaymentInfoViewController) {
        user?.sendEmailVerification(completion: { (error) in
            if let error = error {
                viewController.message = error.localizedDescription
                viewController.finish()
                return
            }
            viewController.message = Constants.Messages.success
            viewController.finish()
        })
    }
}
