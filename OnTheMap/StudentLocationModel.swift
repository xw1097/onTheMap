//
//  StudentModel.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 3/13/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation

final class StudentLocationModel {
    var firstName: String;
    var lastName: String;
    var longitude: Double;
    var latitude: Double;
    var mapString: String;
    var mediaURL: String;
    var uniqueKey: String;
    var objectId: String;
    var createdAt: Date;
    var updatedAt: Date;
    
    init?(json: [String: Any]) {
        self.firstName = json["firstName"]  as! String;
        self.lastName  = json["lastName"]   as! String;
        self.longitude = json["longtitude"] as! Double;
        self.latitude  = json["latitude"]   as! Double;
        self.mapString = json["mapString"]  as! String;
        self.mediaURL  = json["mediaURL"]   as! String;
        self.uniqueKey = json["uniqueKey"]  as! String;
        self.objectId  = json["objectId"]   as! String;
        self.createdAt = json["createdAt"]  as! Date;
        self.updatedAt = json["updatedAt"]  as! Date;
    }
}
