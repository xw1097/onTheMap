//
//  UdacityAuthenticator.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 2/28/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation

final class UdacityAuthenticator {
    static let shared = UdacityAuthenticator()

    public func startSession(withUsername username: String, withPassword password: String, onSuccess: @escaping () -> (), onError: @escaping (String) -> ()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        let bodyJson: [String: Any] = ["udacity": ["username": username, "password": password]]
        let requestJsonData = try? JSONSerialization.data(withJSONObject: bodyJson)
        
        request.httpBody = requestJsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            // Since the API we're working with is fake, the first 5 chars are fake data, so need to trim them out
            let range: Range = 5..<data!.count
            let newData = data?.subdata(in: range)
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
                if let status = parsedResult!["status"] as? NSNumber {
                    if ((status as! NSNumber) != 200) {
                        onError((parsedResult!["error"] as! NSString).localizedUppercase)
                        return
                    }
                }
                if let uniqueKey = (parsedResult!["account"] as? [String: AnyObject])!["key"] as? String {
                    InMemoryStore.shared.userUniqueKey = uniqueKey
                    print("current user uniqueKey is ", uniqueKey)
                    onSuccess()
                }
            } catch {
                onError("Unexpected error happended")
                return
            }
        }
        task.resume()
    }
}
