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
        UdacityClient.getStudentLocations(completion: handleStudentLocationResponse(studentLocations:error:))
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout(completion: handleLogoutResponse(success:error:))
    }
    @IBAction func reload(_ sender: Any) {
    }
    @IBAction func add(_ sender: Any) {
    }
    @IBOutlet weak var showTable: UITabBarItem!
    
    
    func handleStudentLocationResponse(studentLocations: [StudentLocations], error: Error?) {
        
        if error != nil {
            showStudentInformationFailure(message:error?.localizedDescription ?? "")
        } else
        {
            
            print(studentLocations)
            
            // We will create an MKPointAnnotation for each dictionary in "locations". The
            // point annotations will be stored in this array, and then provided to the map view.
            var annotations = [MKPointAnnotation]()
            
            // The "locations" array is loaded with the sample data below. We are using the dictionaries
            // to create map annotations. This would be more stylish if the dictionaries were being
            // used to create custom structs. Perhaps StudentLocation structs.
            
            for studentLocation in studentLocations {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(studentLocation.latitude)
                let long = CLLocationDegrees(studentLocation.longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = studentLocation.firstName
                let last = studentLocation.lastName
                let mediaURL = studentLocation.mediaURL
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            
            // When the array is complete, we add the annotations to the map.
            self.mapView.addAnnotations(annotations)
        }
        
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.   
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string:toOpen)!, options: [:], completionHandler: nil)
            }
        }
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
    
    func showStudentInformationFailure(message: String) {
        let alertVC = UIAlertController(title: "Downloading student information failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}
