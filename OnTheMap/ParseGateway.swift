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
    
    public func getStudentLocation(onSuccess: @escaping (Array<StudentLocationModel>) -> (), onError: @escaping (String) -> ()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!);
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            let parsedResult: [String: Any]!
            var location: [StudentLocationModel] = [];
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any];
                for case let result in (parsedResult!["results"] as? Array<Any>)! {
                    if let studentLocaltion = StudentLocationModel(json: (result as? [String: Any])!) {
                        location.append(studentLocaltion)
                    }
                }
            } catch {
                onError("Could not parse the data as JSON: '\(data)'")
                return
            }
        
        }
        task.resume()
    }
}
