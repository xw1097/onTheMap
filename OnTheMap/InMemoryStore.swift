//
//  InMemoryStore.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 3/13/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation

// A simple class to store app states and data
final class InMemoryStore {
    static let shared = InMemoryStore()
    
    var userUniqueKey: String // user identifier, user post also is associated with this ke
    var cachedStudentInformations: Array<StudentInformation>!
    
    private init() {
        self.userUniqueKey = ""
        self.cachedStudentInformations = [];
    }
}
