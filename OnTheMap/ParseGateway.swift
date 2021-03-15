//
//  ParseGateway.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 3/13/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation

final class ParseGateway {
    static let shared = ParseGateway();
    
    public func getStudentLocation(onSuccess: @escaping (Array<StudentInformation>) -> (), onError: @escaping (String) -> ()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!);
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            let parsedResult: [String: Any]!
            var location: [StudentInformation] = [];
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any];
                for case let result in (parsedResult!["results"] as? Array<Any>)! {
                    if let studentLocaltion = StudentInformation(json: (result as? [String: Any])!) {
                        location.append(studentLocaltion)
                    }
                }
                onSuccess(location);
            } catch {
                onError("Could not parse the data as JSON: '\(data)'")
                return
            }
        
        }
        task.resume()
    }
    
//    public postStudentLocation() {
//        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//        if error != nil { // Handle error…
//        return
//        }
//        print(String(data: data!, encoding: .utf8)!)
//        }
//        task.resume()
//    }
}
