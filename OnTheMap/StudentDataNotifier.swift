//
//  StudentDataNotifier.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 4/20/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation

class StudentDataNotifier {
    static let shared = StudentDataNotifier()
    static let MAP_VIEW_SUBSCRIBER_NAME = "MAP_VIEW_SUBSCRIBER_NAME"
    static let TABLE_VIEW_SUBSCRIBER_NAME = "TABLE_VIEW_SUBSCRIBER_NAME"
    private var subCallbacks: [()-> Void] = []
    private var subscriberNameSet: [String]
    
    private init() {
        self.subCallbacks = []
        self.subscriberNameSet = [];
    }
    
    func subscribe(_ name: String, callback: @escaping () -> ()) -> Void {
        if (subscriberNameSet.contains(name) == false) {
            subCallbacks.append(callback)
        }
    }
    
    func notify() {
        for callback in subCallbacks {
            callback()
        }
    }
}
