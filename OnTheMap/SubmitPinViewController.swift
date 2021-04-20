//
//  SubmitPinViewController.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 4/11/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SubmitPinViewController: UIViewController, UITextViewDelegate  {
    var studentInfo: StudentInformation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var linkToShare: UITextView!
    
    @IBAction func submitAction(_ sender: Any) {
        self.studentInfo?.mediaURL = linkToShare.text
        self.renderSpinner()
        ParseGateway.shared.postStudentLocation(firstName: "John", lastName: "Snow", addressString: self.studentInfo!.mapString, mediaURL: self.studentInfo!.mediaURL, latitude: self.studentInfo!.latitude, longitude: self.studentInfo!.longitude, onSuccess: self.onSuccess, onError: self.onError)
    }
    
    override func viewDidLoad() {
        self.linkToShare.delegate = self
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.studentInfo!.latitude, longitude: self.studentInfo!.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        self.linkToShare.delegate = self
    }
    
    private func onError(_ error: String) {
        DispatchQueue.main.async {
            self.dismissSpinner()
            let alert = UIAlertController(title: "error", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    private func onSuccess() {
        DispatchQueue.main.async {
            self.dismissSpinner()
            self.performSegue(withIdentifier: "backToMapSegue", sender: nil)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
