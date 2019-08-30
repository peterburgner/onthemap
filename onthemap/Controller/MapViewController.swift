//
//  MapViewController.swift
//  onthemap
//
//  Created by Peter Burgner on 8/28/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UITabBarItem!
    @IBOutlet weak var tableButton: UITabBarItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.getStudentLocations(completion: handleStudentLocationResponse(studentInformation:error:))
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout(completion: handleLogoutResponse(success:error:))
    }
    @IBAction func reload(_ sender: Any) {
    }
    @IBAction func add(_ sender: Any) {
    }
    @IBOutlet weak var showTable: UITabBarItem!
    
    
    func handleStudentLocationResponse(studentInformation: [StudentInformation], error: Error?) {
        print(studentInformation)
    }
    
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
    
}
