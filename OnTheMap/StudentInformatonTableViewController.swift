//
//  StudentInformatonTableViewController.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 4/6/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation
import UIKit

class StudentInformationTableViewController: UITableViewController {
    static let CELL_REUSABLE_ID = "StudentInformationTableViewCell"
    @IBAction func refreshLocations(_ sender: Any) {
        self.viewDidLoad();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // get cached information
        ParseGateway.shared.getStudentLocation(force: false, onSuccess: self.fetchSuccess, onError: self.fetchError);
    }

    private func fetchSuccess(_ locations: Array<StudentInformation>) {
        DispatchQueue.main.async {
            InMemoryStore.shared.cachedStudentInformations = locations;
        }
    }
    
    private func fetchError(_ errorText: String) {
        let alert = UIAlertController(title: "Failed to fetch info, please retry", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InMemoryStore.shared.cachedStudentInformations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = InMemoryStore.shared.cachedStudentInformations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentInformationTableViewController.CELL_REUSABLE_ID) as! StudentInformationTableCell?

        cell?.nameLabel!.text = student.firstName + " " + student.lastName
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaURL = InMemoryStore.shared.cachedStudentInformations[indexPath.row].mediaURL
        Utils.openUrl(urlToOpen: mediaURL)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
