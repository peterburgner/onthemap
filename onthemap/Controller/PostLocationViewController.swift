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
        prepareUI()
    }
    
    func prepareUI() {
        // Prepare map
        map.centerCoordinate = placemark[0].location!.coordinate
        let mkPlacemark = MKPlacemark(placemark: placemark[0])
        map.addAnnotation(mkPlacemark)
    }       
    
    @IBAction func postLocation(_ sender: Any) {
    }
}
