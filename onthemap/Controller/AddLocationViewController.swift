//
//  AddLocationViewController.swift
//  onthemap
//
//  Created by Peter Burgner on 8/30/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    // MARK: Variables
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var findLocationButton: UdacityButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var geocoding = false
    var geocodedLocation = CLPlacemark()
    var alreadyAdjustedOriginY = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: IBActions
    @IBAction func findLocation(_ sender: Any) {
        setGeocoding(true)
        if url.text != "" {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location.text ?? "", completionHandler: handleGeocodeLocationString(placemark:error:))
        } else {
            setGeocoding(false)
            showMissingURLError()
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "tabbarController") as! UITabBarController
        present(tabbarVC, animated: true, completion: nil)
    }
    
    // MARK: Functions
    func handleGeocodeLocationString (placemark: [CLPlacemark]?, error: Error?) -> Void {
        guard let error = error else {
            if let placemark = placemark {
                let postLocationViewController = storyboard?.instantiateViewController(withIdentifier: "PostLocation") as! PostLocationViewController
                postLocationViewController.placemark = placemark
                postLocationViewController.mediaURL = url.text ?? ""
                present(postLocationViewController, animated: true, completion: nil)
            }
            return
        }
        showGeocodeLocationStringError(message: error.localizedDescription)
    }
    
    func showGeocodeLocationStringError(message: String) {
        let alertVC = UIAlertController(title: "Could not find Location", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func showMissingURLError() {
        let alertVC = UIAlertController(title: "No URL given", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func setGeocoding(_ geocoding: Bool) {
        if geocoding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        location.isEnabled = !geocoding
        url.isEnabled = !geocoding
        findLocationButton.isEnabled = !geocoding
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (location.isEditing || url.isEditing) && (!alreadyAdjustedOriginY) {
            let buttonOrigin = findLocationButton.frame.origin.y
            let keyboardHeight = getKeyboardHeight(notification)
            let offset = buttonOrigin-keyboardHeight
            view.frame.origin.y -= offset
            alreadyAdjustedOriginY = true
        }
    }
    
    @objc func keyboardWillDisappear(_ notification:Notification) {
        view.frame.origin.y = 0
        alreadyAdjustedOriginY = false
    }
    
    // MARK: NSNotifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
