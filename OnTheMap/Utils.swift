//
//  Utils.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 4/18/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func openUrl(urlToOpen: String) {
        let app = UIApplication.shared
        if (app.canOpenURL(URL(string: urlToOpen)!)) {
            app.open(URL(string: urlToOpen)!)
        }
    }
}
