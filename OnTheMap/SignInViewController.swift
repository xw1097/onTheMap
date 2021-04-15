//
//  ViewController.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 2/28/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginErrorTextDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLoginErrorText("");
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        self.setLoginErrorText("");
        let username = emailTextView.text!
        let password = passwordTextView.text!
        UdacityAuthenticator.shared.startSession(withUsername: username, withPassword: password, onSuccess: self.onLoginSuccess, onError: self.setLoginErrorText)
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    private func setLoginErrorText(_ text: String) {
        DispatchQueue.main.async {
            self.loginErrorTextDisplay.text = text
        }
    }
    
    private func onLoginSuccess() {
        DispatchQueue.main.async {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
}

