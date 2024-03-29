//
//  UIViewController+Extension.swift
//  onthemap
//
//  Created by Peter Burgner on 8/29/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK IBActions
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    @IBAction func add(_ sender: Any) {
    }
    
    
    // MARK Functions
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "login", sender: nil)
        } else {
            showLogoutFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLogoutFailure(message: String) {
        let alertVC = UIAlertController(title: "Logout failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func showStudentInformationFailure(message: String) {
        let alertVC = UIAlertController(title: "Download of Student Information failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

}
