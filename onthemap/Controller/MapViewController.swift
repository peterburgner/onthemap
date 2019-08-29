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
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout()
        performSegue(withIdentifier: "login", sender: nil)
    }
    @IBAction func reload(_ sender: Any) {
    }
    @IBAction func add(_ sender: Any) {
    }
    @IBOutlet weak var showTable: UITabBarItem!
}
