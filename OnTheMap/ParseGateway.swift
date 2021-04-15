//
//  ParseGateway.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 3/13/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation

final class ParseGateway {
    static let shared = ParseGateway()
    
    public func getStudentLocation(force: Bool, onSuccess: @escaping (Array<StudentInformation>) -> (), onError: @escaping (String) -> ()) {
        if (force == false && InMemoryStore.shared.cachedStudentInformations.count > 0) {
            return
        }
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            let parsedResult: [String: Any]!
            var locations: [StudentInformation] = []
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                for case let result in (parsedResult!["results"] as? Array<Any>)! {
                    if let studentLocaltion = StudentInformation(json: (result as? [String: Any])!) {
                        locations.append(studentLocaltion)
                    }
                }
                InMemoryStore.shared.cachedStudentInformations = locations;
                onSuccess(locations)
            } catch {
                onError("Could not parse the data as JSON: '\(data)'")
                return
            }
        
        }
        task.resume()
    }
    
    public func postStudentLocation(firstName: String, lastName: String, addressString: String, mediaURL: String, latitude: Double, longitude: Double, onSuccess: @escaping () -> (), onError: @escaping (String) -> ()) -> Void {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(addressString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
    
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                onError("post location failed, please try again")
            } else {
                print(response)
                onSuccess()
            }
        }
        task.resume()
    }
}
