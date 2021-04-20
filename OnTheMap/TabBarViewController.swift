//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 4/19/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewControlelr: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        ParseGateway.shared.getStudentLocation(onSuccess: self.fetchSuccess, onError: self.onError)
    }
    
    @IBAction func addPin(_ sender: Any) {
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
    
    @IBAction func refresh(_ sender: Any) {
        ParseGateway.shared.getStudentLocation(onSuccess: self.fetchSuccess, onError: self.onError)
    }
    
    @IBAction func logOut(_ sender: Any) {
        UdacityAuthenticator.shared.deleteSession(
            onSuccess: self.logOutSuccess,
            onError: self.onError)
    }
    
    private func fetchSuccess(_ locations: Array<StudentInformation>) {
        InMemoryStore.shared.cachedStudentInformations = locations;
        // notify current selected view controller
        StudentDataNotifier.shared.notify()
    }
    
    private func onError(_ error: String) {
        let alert = UIAlertController(title: "Something went wrong, please try again", message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func logOutSuccess() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
