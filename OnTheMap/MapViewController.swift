//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 3/13/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func refreshLocations(_ sender: Any) {
        self.viewDidLoad()
    }
    
    @IBAction func logOut(_ sender: Any) {
        UdacityAuthenticator.shared.deleteSession(
            onSuccess: self.logOutSuccess,
            onError: self.onError)
    }
    
    @IBAction func postPin(_ sender: Any) {
        var isDuplicate = false
        for item in InMemoryStore.shared.cachedStudentInformations {
            if (item.uniqueKey == InMemoryStore.shared.userUniqueKey) {
                isDuplicate = true
            }
        }
        if (isDuplicate) {
            let alert = UIAlertController(title: "You have Already Posted a Student Location. Would You Like to Overwrite You Current Location?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                self.performSegue(withIdentifier: "AddPinDetailPage", sender: nil);
            }))
            
            self.present(alert, animated: true)
        } else {
            performSegue(withIdentifier: "AddPinDetailPage", sender: nil);
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        mapView.delegate = self
        ParseGateway.shared.getStudentLocation(force: true, onSuccess: self.fetchSuccess, onError: self.fetchError)
    }
    
    private func fetchSuccess(_ locations: Array<StudentInformation>) {
        DispatchQueue.main.async {
            // We will create an MKPointAnnotation for each dictionary in "locations". The
            // point annotations will be stored in this array, and then provided to the map view.
            var annotations = [MKPointAnnotation]()
            
            // The "locations" array is loaded with the sample data below. We are using the dictionaries
            // to create map annotations. This would be more stylish if the dictionaries were being
            // used to create custom structs. Perhaps StudentLocation structs.
            
            for location in locations {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(location.latitude);
                let long = CLLocationDegrees(location.longitude);
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = location.firstName;
                let last = location.lastName;
                let mediaURL = location.mediaURL;
                
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

    
    private func fetchError(_ errorText: String) {
        let alert = UIAlertController(title: "Failed to fetch info, please retry", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func onError(_ error: String) {
        let alert = UIAlertController(title: "Logout failed, please try again", message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func logOutSuccess() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
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
            if let toOpen = view.annotation?.subtitle! {
                Utils.openUrl(urlToOpen: toOpen)
            }
        }
    }

}
