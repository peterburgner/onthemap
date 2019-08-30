//
//  ViewController.swift
//  onthemap
//
//  Created by Peter Burgner on 8/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {


    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.textContentType = .username
        passwordField.textContentType = .password
    }
    
    @IBAction func login(_ sender: Any) {
        UdacityClient.login(username: emailField.text ?? "", password: passwordField.text ?? "", completion: handleLoginResponse(success:error:) )
    }
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signup.url)
    }
    
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


}

