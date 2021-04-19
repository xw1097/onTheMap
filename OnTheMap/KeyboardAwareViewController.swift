//
//  KeyboardAwareViewController.swift
//  OnTheMap
//
//  Created by Xicheng Wang on 4/18/21.
//  Copyright © 2021 xichengw. All rights reserved.
//

import Foundation
import UIKit

/**
 * An opinionated view controller that helps other view controller to address following issue:
 * When a keyboard is shown, we do not know if the keyboard would overlay with the component that we're
 * current inputing text
 * With this class, you need to implement only method
 * isKeyBoardAwareComponentEditing - you should return true if a particular component would overlap with keyboard
 *     of course, we can be smart with math that we check if a particualr component's x & y position and check
 *     the component type(aka textField/textView etc) and make a decision, but that's too much work
 *     and maintianence heavy, so I chose to do the simpler way
 *
 * This VC also leaves the responsibility to dev about how to track which view is current editing
 * because that is essential to how to implement isKeyBoardAwareComponentEditing.
 */
class KeyboardAwareViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        subscribeToKeyboardNotifications();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        unsubscribeFromKeyboardNotifications();
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil);
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        // we only want to offset once in case user switch editing between text field
        // so we need to check if y is offscreen
        if (self.isKeyBoardAwareComponentEditing() && view.frame.origin.y >= 0) {
            view.frame.origin.y -= getKeyboardHeight(notification);
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if (view.frame.origin.y < 0) { // y is offscreen, we should retore y to 0
            view.frame.origin.y = 0;
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo;
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue;
        return keyboardSize.cgRectValue.height;
    }
    
    func isKeyBoardAwareComponentEditing() -> Bool {
        fatalError("Need to override this method")
    }
}
