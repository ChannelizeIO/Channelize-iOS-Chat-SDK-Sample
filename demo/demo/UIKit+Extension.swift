//
//  UIKit+Extension.swift
//  demo
//
//  Created by Ashish-BigStep on 1/16/20.
//  Copyright © 2020 Channelize. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setLeftPadding(withPadding:CGFloat){
        let deviceSpecificPadding = (UIScreen.main.bounds.width*withPadding)/667
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: deviceSpecificPadding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround(cancelTouchInView:Bool = true) {
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouchInView
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
