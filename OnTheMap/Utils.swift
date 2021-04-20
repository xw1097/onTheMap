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

fileprivate var spinnerView: UIView?

extension UIViewController {
    // render a spinner view on top existing VC
    func renderSpinner() {
        spinnerView = UIView(frame: self.view.bounds)
        spinnerView!.backgroundColor = .white
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = .gray
        spinner.center = spinnerView!.center
        spinnerView!.addSubview(spinner)
        spinner.startAnimating()
        self.view.addSubview(spinnerView!)
    }
    
    func dismissSpinner() {
        spinnerView?.removeFromSuperview()
    }
}
