//
//  PostLocation.swift
//  onthemap
//
//  Created by Peter Burgner on 9/1/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var placemark = [CLPlacemark]()
    var mediaURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()

    }
    
    func prepareUI() {
        // Prepare map
        map.centerCoordinate = placemark[0].location!.coordinate
        map.addAnnotation(MKPlacemark(placemark: placemark[0]))
    }       
    
    @IBAction func postLocation(_ sender: Any) {
        UdacityClient.postNewStudentLocation(location: MKPlacemark(placemark: placemark[0]), mediaURL: mediaURL, completion: handlePostLocation(success:error:))
    }

    func handlePostLocation (success: Bool, error: Error?) {
        if success {            
            let tabbarVC = storyboard?.instantiateViewController(withIdentifier: "tabbarController") as! UITabBarController
            present(tabbarVC, animated: true, completion: nil)
        } else {
            showPostingFailedError()
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func showPostingFailedError() {
        let alertVC = UIAlertController(title: "Post failed", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}
