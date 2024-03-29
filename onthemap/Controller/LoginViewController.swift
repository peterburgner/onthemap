//
//  ViewController.swift
//  onthemap
//
//  Created by Peter Burgner on 8/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // TODO: Add activity indicator

    // MARK: - Variables
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    var alreadyAdjustedOriginY = false
    
    // MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.textContentType = .username
        passwordField.textContentType = .password
        subscribeToKeyboardNotifications()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func login(_ sender: Any) {
        let errorMessage = "Please enter username and password"
        if emailField.text == "" || passwordField.text == "" {
            showLoginFailure(message: errorMessage)
        } else {
            UdacityClient.login(username: emailField.text ?? "", password: passwordField.text ?? "", completion: handleLoginResponse(success:error:) )
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signup.url)
    }
    
    
    // MARK: - Functions
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "showMap", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        endEditing()
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (emailField.isEditing || passwordField.isEditing) && (!alreadyAdjustedOriginY) {
            view.frame.origin.y -= 50
            alreadyAdjustedOriginY = true
        }
    }
    
    @objc func keyboardWillDisappear(_ notification:Notification) {
        endEditing()
    }
    
    @objc func endEditing() {
        view.frame.origin.y = 0
        alreadyAdjustedOriginY = false
    }
    
    // MARK: - NSNotifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

