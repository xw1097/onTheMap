//
//  PostPinViewController.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 4/11/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class PostPinViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var locationTextView: UITextView!
    
    
    @IBAction func findOnTheMapAction(_ sender: Any) {
        self.getCoordinate(addressString: self.locationTextView.text, completionHandler: {coord, error in
            if (error != nil) {
                let alert = UIAlertController(title: "Error converting your location into geocode", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            } else {
                var studentInfo = StudentInformation()
                studentInfo.latitude = coord.latitude
                studentInfo.longitude = coord.longitude
                studentInfo.mapString = self.locationTextView.text
                self.performSegue(withIdentifier: "findOnTheMapSegue", sender: studentInfo);
            }
        })
    }
    
    override func viewDidLoad() {
        self.locationTextView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    
    // https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
    func getCoordinate(addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let submitPinVC = segue.destination as! SubmitPinViewController;
        let studentInfo = sender as! StudentInformation;
        submitPinVC.studentInfo = studentInfo;
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    
}
