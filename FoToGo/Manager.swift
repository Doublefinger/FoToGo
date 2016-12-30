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
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference(forURL: "gs://" + (FIRApp.defaultApp()?.options.storageBucket!)!)
    
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
                self.signedIn(user!, viewController: viewController)
            } else {
                viewController.message = Constants.Messages.notVerified
                viewController.finish()
            }
        })
    }
    
    func retrieveUserInfo() {
        self.ref.child("users").queryOrderedByKey().queryEqual(toValue: AppState.sharedInstance.uid).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            let userData = snapshot.value as! NSDictionary
            AppState.sharedInstance.mobile = userData["mobile"] as? String
            AppState.sharedInstance.year = userData["year"] as? String
        })
    }
    
    func updateUserInfo(_ hasImage: Bool, userInfo: UserInfo, viewController: EditAccountViewController) {
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = userInfo.firstName + " " + userInfo.lastName
        
        if hasImage {
            let imageData = UIImageJPEGRepresentation(userInfo.photo, 1.0)
            let imagePath = AppState.sharedInstance.uid! + "_profile.jpg"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            self.storageRef.child(imagePath).put(imageData!, metadata: metadata, completion: { (metadata, error) in
                if let error = error {
                    viewController.message = error.localizedDescription
                    viewController.finish()
                    return
                }
                changeRequest?.photoURL = URL(string: self.storageRef.child((metadata?.path)!).description)
                self.commitChangeRequest(changeRequest!, userInfo: userInfo, newURL: true, viewController: viewController)
            })
        } else {
            self.commitChangeRequest(changeRequest!, userInfo: userInfo, newURL: false, viewController: viewController)
        }
    }
    
    func signOut() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.clear()
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
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
    private func registerDataToCustomTable(_ user: FIRUser, id: String, userInfo: UserInfo, viewController: PaymentInfoViewController){
        var uData = [String: Any]()
        uData[Constants.UserFields.mobile] = userInfo.mobile
        uData[Constants.UserFields.year] = userInfo.major
        uData[Constants.UserFields.name] = userInfo.firstName
        self.ref.child("users").child(id).setValue(uData) { (error, ref) in
            if let error = error {
                viewController.message = error.localizedDescription
                viewController.finish()
                return
            }
            self.sendEmailVerfication(user, viewController: viewController)
        }
    }
    
    private func commitChangeRequest(_ changeRequest: FIRUserProfileChangeRequest, userInfo: UserInfo, newURL: Bool, viewController: EditAccountViewController) {
        changeRequest.commitChanges { (error) in
            if let error = error {
                viewController.message = error.localizedDescription
                viewController.finish()
                return
            }
            AppState.sharedInstance.displayName = changeRequest.displayName
            if newURL {
                AppState.sharedInstance.profileImage = userInfo.photo
            }
            if userInfo.email != AppState.sharedInstance.email {
                FIRAuth.auth()?.currentUser?.updateEmail(userInfo.email, completion: { (error) in
                    if let error = error {
                        viewController.message = error.localizedDescription
                        viewController.finish()
                        return
                    }
                    AppState.sharedInstance.email = userInfo.email
                    self.updateUserCustomTable(userInfo.mobile, userInfo.firstName, viewController: viewController)
                })
            } else {
                self.updateUserCustomTable(userInfo.mobile, userInfo.firstName, viewController: viewController)
            }
        }
    }

    private func updateUserCustomTable(_ mobile: String, _ name: String, viewController: EditAccountViewController) {
        self.ref.child("users").child(AppState.sharedInstance.uid! + "/mobile").setValue(mobile) { (error, ref) in
            if let error = error {
                viewController.message = error.localizedDescription
                viewController.finish()
                return
            }
            AppState.sharedInstance.mobile = mobile
            self.ref.child("users").child(AppState.sharedInstance.uid! + "/name").setValue(name) { (error, ref) in
                if let error = error {
                    viewController.message = error.localizedDescription
                    viewController.finish()
                    return
                }
                viewController.message = Constants.Messages.success
                viewController.finish()
            }
        }
    }
    
    private func registerInfo(_ user: FIRUser, _ userInfo: UserInfo, viewController: PaymentInfoViewController){
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = userInfo.firstName + " " + userInfo.lastName
        changeRequest.commitChanges { (error) in
            if let error = error {
                viewController.message = error.localizedDescription
                viewController.finish()
                return
            }
            self.registerDataToCustomTable(user, id: user.uid, userInfo: userInfo, viewController: viewController)
        }
    }
    
    private func signedIn(_ user: FIRUser?, viewController: SignInViewController) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.uid = user?.uid
        self.retrieveUserInfo()
        AppState.sharedInstance.displayName = user?.displayName
        AppState.sharedInstance.email = user?.email
        AppState.sharedInstance.signedIn = true

        if let url = user?.photoURL {
            FIRStorage.storage().reference(forURL: url.absoluteString).data(withMaxSize: INT64_MAX, completion: { (data, error) in
                if error != nil {
                    AppState.sharedInstance.profileImage = UIImage(named: "user_default")
                } else {
                    AppState.sharedInstance.profileImage = UIImage(data: data!)
                }
                viewController.message = Constants.Messages.success
                viewController.finish()
            })
        } else {
            AppState.sharedInstance.profileImage = UIImage(named: "user_default")
            viewController.message = Constants.Messages.success
            viewController.finish()
        }
//        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
//        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
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
