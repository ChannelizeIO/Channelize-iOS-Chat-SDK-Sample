//
//  ViewController.swift
//  AMLoginSingup
//
//  Created by amir on 10/11/16.
//  Copyright © 2016 amirs.eu. All rights reserved.
//

import UIKit
import ZVProgressHUD
import Channelize
import Channelize_API

enum AMLoginSignupViewMode {
    case login
    case signup
}

class ViewController: UIViewController {
    
    
    let animationDuration = 0.25
    var mode:AMLoginSignupViewMode = .signup
    
    
    //MARK: - background image constraints
    @IBOutlet weak var backImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - login views and constrains
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginWidthConstraint: NSLayoutConstraint!
    
    
    //MARK: - signup views and constrains
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupContentView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonTopConstraint: NSLayoutConstraint!
    
    
    //MARK: - logo and constrains
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButtomInSingupConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
   
    
    @IBOutlet weak var forgotPassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialsView: UIView!
    
    
    //MARK: - input views
    @IBOutlet weak var loginEmailInputView: AMInputView!
    @IBOutlet weak var loginPasswordInputView: AMInputView!
    @IBOutlet weak var signupEmailInputView: AMInputView!
    @IBOutlet weak var signupPasswordInputView: AMInputView!
    @IBOutlet weak var signupPasswordConfirmInputView: AMInputView!
    
    
    
    //MARK: - controller
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ZVProgressHUD.maskType = .custom(color: lightestGray.withAlphaComponent(0.20))
        ZVProgressHUD.minimumDismissTimeInterval = 0.4
        ZVProgressHUD.displayStyle = .custom(backgroundColor: .white, foregroundColor: appDefaultColor)
        
        // set view to login mode
        toggleViewMode(animated: false)
        signupContentView.layer.cornerRadius = 10
        //add keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboarFrameChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if(Channelize.main.currentUserId() != nil){
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
                CHMain.instance.launchApp(navigationController: navigationController, data: nil)
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - button actions
    @IBAction func loginButtonTouchUpInside(_ sender: AnyObject) {
   
        if mode == .signup {
             toggleViewMode(animated: true)
        
        }else{
            ZVProgressHUD.show(with: "Signing in")
            guard let email = loginEmailInputView.textFieldView.text, let password = loginPasswordInputView.textFieldView.text,!email.isEmpty,!password.isEmpty else {
                print("Form is not valid")
                return
            }
            
            Channelize.main.login(username: email, password: password){(user,error) in
                if error != nil {
                    ZVProgressHUD.showError()
                }else{
                    ZVProgressHUD.showSuccess()
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
                        
                        CHMain.instance.launchApp(navigationController: navigationController, data: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func signupButtonTouchUpInside(_ sender: AnyObject) {
   
        if mode == .login {
            toggleViewMode(animated: true)
        }else{
            
        }
    }
    
    
    
    //MARK: - toggle view
    func toggleViewMode(animated:Bool){
    
        // toggle mode
        mode = mode == .login ? .signup:.login
        
        
        // set constraints changes
        backImageLeftConstraint.constant = mode == .login ? 0:-self.view.frame.size.width
        
        
        loginWidthConstraint.isActive = mode == .signup ? true:false
        logoCenterConstraint.constant = (mode == .login ? -1:1) * (loginWidthConstraint.multiplier * self.view.frame.size.width)/2
        loginButtonVerticalCenterConstraint.priority = mode == .login ? UILayoutPriority(rawValue: 300):UILayoutPriority(rawValue: 900)
        signupButtonVerticalCenterConstraint.priority = mode == .signup ? UILayoutPriority(rawValue: 300):UILayoutPriority(rawValue: 900)
        
        
        //animate
        self.view.endEditing(true)
        
        UIView.animate(withDuration:animated ? animationDuration:0) {
            
            //animate constraints
            self.view.layoutIfNeeded()
            
            //hide or show views
            self.loginContentView.alpha = self.mode == .login ? 1:0
            self.signupContentView.alpha = self.mode == .signup ? 1:0
            self.logoView.tintColor = self.mode == .login ? .white : UIColor(hex: "#1761b6")
            self.socialsView.tintColor = self.mode == .login ? .white : UIColor(hex: "#1761b6")
            
            // rotate and scale login button
            let scaleLogin:CGFloat = self.mode == .login ? 1:0.4
            let rotateAngleLogin:CGFloat = self.mode == .login ? 0:CGFloat(-Double.pi/2)
            
            var transformLogin = CGAffineTransform(scaleX: scaleLogin, y: scaleLogin)
            transformLogin = transformLogin.rotated(by: rotateAngleLogin)
            self.loginButton.transform = transformLogin
            
            
            // rotate and scale signup button
            let scaleSignup:CGFloat = self.mode == .signup ? 1:0.4
            let rotateAngleSignup:CGFloat = self.mode == .signup ? 0:CGFloat(-Double.pi/2)
            
            var transformSignup = CGAffineTransform(scaleX: scaleSignup, y: scaleSignup)
            transformSignup = transformSignup.rotated(by: rotateAngleSignup)
            self.signupButton.transform = transformSignup
        }
        
    }
    
    
    //MARK: - keyboard
    @objc func keyboarFrameChange(notification:NSNotification){
        
        let userInfo = notification.userInfo as! [String:AnyObject]
        
        // get top of keyboard in view
        let topOfKetboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue .origin.y
        
        
        // get animation curve for animate view like keyboard animation
        var animationDuration:TimeInterval = 0.25
        var animationCurve:UIView.AnimationCurve = .easeOut
        if let animDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
            animationDuration = animDuration.doubleValue
        }
        
        if let animCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationCurve =  UIView.AnimationCurve.init(rawValue: animCurve.intValue)!
        }
        
        
        // check keyboard is showing
        let keyboardShow = topOfKetboard != self.view.frame.size.height
        
        
        //hide logo in little devices
        let hideLogo = self.view.frame.size.height < 667
        
        // set constraints
        backImageBottomConstraint.constant = self.view.frame.size.height - topOfKetboard
        
        logoTopConstraint.constant = keyboardShow ? (hideLogo ? 0:20):50
        logoHeightConstraint.constant = keyboardShow ? (hideLogo ? 0:40):60
        logoBottomConstraint.constant = keyboardShow ? 20:32
        logoButtomInSingupConstraint.constant = keyboardShow ? 20:32
        
        forgotPassTopConstraint.constant = keyboardShow ? 30:45
        
        loginButtonTopConstraint.constant = keyboardShow ? 25:30
        signupButtonTopConstraint.constant = keyboardShow ? 23:35
        
        loginButton.alpha = keyboardShow ? 1:0.7
        signupButton.alpha = keyboardShow ? 1:0.7
        
        
        
        // animate constraints changes
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
        
    }
    
    //MARK: - hide status bar in swift3
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  
}

