//
//  PostLocation.swift
//  onthemap
//
//  Created by Peter Burgner on 9/1/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    var placemark = [CLPlacemark]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(placemark)
    }
    
    @IBAction func postLocation(_ sender: Any) {
    }
}
