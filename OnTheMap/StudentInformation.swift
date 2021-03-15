//
//  StudentModel.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 3/13/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation

final class StudentInformation {
    var firstName: String;
    var lastName: String;
    var longitude: Double;
    var latitude: Double;
    var mapString: String;
    var mediaURL: String;
    var uniqueKey: String;
    var objectId: String;
    var createdAt: String;
    var updatedAt: String;
    
    init?(json: [String: Any]) {
        self.firstName = json["firstName"]  as! String;
        self.lastName  = json["lastName"]   as! String;
        self.longitude = json["longitude"] as! Double;
        self.latitude  = json["latitude"]   as! Double;
        self.mapString = json["mapString"]  as! String;
        self.mediaURL  = json["mediaURL"]   as! String;
        self.uniqueKey = json["uniqueKey"]  as! String;
        self.objectId  = json["objectId"]   as! String;
        self.createdAt = json["createdAt"]  as! String;
        self.updatedAt = json["updatedAt"]  as! String;
    }
    
    // sample data
    //    "createdAt" : "2015-02-24T22:27:14.456Z",
    //    "firstName" : "Jessica",
    //    "lastName" : "Uelmen",
    //    "latitude" : 28.1461248,
    //    "longitude" : -82.75676799999999,
    //    "mapString" : "Tarpon Springs, FL",
    //    "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
    //    "objectId" : "kj18GEaWD8",
    //    "uniqueKey" : 872458750,
    //    "updatedAt" : "2015-03-09T22:07:09.593Z"
}
