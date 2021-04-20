//
//  ViewController.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 2/28/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import UIKit

class SignInViewController: KeyboardAwareViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginErrorTextDisplay: UILabel!

    private var currentEditingTextField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLoginErrorText("");
        self.emailTextView.delegate = self
        self.passwordTextView.delegate = self
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
            self.emailTextView.text = ""
            self.passwordTextView.text = ""
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentEditingTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentEditingTextField = nil
    }
    
    override func isKeyBoardAwareComponentEditing() -> Bool {
        if (self.currentEditingTextField != nil) {
            return self.currentEditingTextField! == self.passwordTextView
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.currentEditingTextField = nil
        textField.resignFirstResponder()
        return true
    }
}

