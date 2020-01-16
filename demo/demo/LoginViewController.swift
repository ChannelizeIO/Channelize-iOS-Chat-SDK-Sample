//
//  LoginViewController.swift
//  demo
//
//  Created by Ashish-BigStep on 1/16/20.
//  Copyright © 2020 Channelize. All rights reserved.
//

import UIKit
import Channelize_API
import Channelize
import ZVProgressHUD
import ZVActivityIndicatorView

enum NormalUserSignUpError {
    case emailError
    case passwordError
    case apiError
}

class LoginViewController: UIViewController {
    
    private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.tag = 1001
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.tintColor = .black
        textField.keyboardType = .emailAddress
        textField.textContentType = UITextContentType(rawValue: "")
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 13.0
        textField.autocorrectionType = .no
        textField.setLeftPadding(withPadding: 20)
        textField.tintColor = .black
        textField.clearButtonMode = .whileEditing
        textField.inputAccessoryView = nil
        textField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.kern:1.5,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17.0, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: "Email",attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.kern:1.5,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17.0, weight: .medium)])
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.tag = 1001
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.tintColor = .black
        textField.keyboardType = .default
        textField.textContentType = UITextContentType(rawValue: "")
        textField.isSecureTextEntry = true
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 13.0
        textField.autocorrectionType = .no
        textField.setLeftPadding(withPadding: 20)
        textField.tintColor = .black
        textField.clearButtonMode = .whileEditing
        textField.inputAccessoryView = nil
        textField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.kern:1.5,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17.0, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: "Password",attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.kern:1.5,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17.0, weight: .medium)])
        return textField
    }()
    
    private var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = defaultColor
        button.layer.cornerRadius = 10.0
        //button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 10.0
        button.layer.shadowOpacity = 1.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("No account yet? Create one", for: .normal)
        button.setTitleColor(defaultColor, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.numberOfLines = 0
        //button.layer.cornerRadius = 10.0
        //button.layer.masksToBounds = true
        //button.layer.shadowColor = UIColor.lightGray.cgColor
        //button.layer.shadowOffset = CGSize(width: 0, height: 5)
        //button.layer.shadowRadius = 10.0
        //button.layer.shadowOpacity = 1.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround(cancelTouchInView: false)
        self.view.backgroundColor = .white
        self.setUpViews()
        self.setUpViewsFrames()
        
        if Channelize.currentUserId() != nil{
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
                navigationController.setNavigationBarHidden(true, animated: false)
                CHMain.launchApp(navigationController: navigationController, data: nil)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if isMovingToParent {
            
        }
        if isMovingFromParent{
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUpViews() {
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        self.loginButton.addTarget(self, action: #selector(doLogin(sender:)), for: .touchUpInside)
        self.registerButton.addTarget(self, action: #selector(doSignUp(sender:)), for: .touchUpInside)
    }
    
    private func setUpViewsFrames() {
        self.emailTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        self.emailTextField.widthAnchor.constraint(equalToConstant: 290).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 30).isActive = true
        self.passwordTextField.widthAnchor.constraint(equalToConstant: 290).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30).isActive = true
        self.loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        self.registerButton.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 30).isActive = true
        self.registerButton.widthAnchor.constraint(equalToConstant: 290).isActive = true
        self.registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }
    
    @objc private func doSignUp(sender: UIButton) {
        let controller = SignUpScreenViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func doLogin(sender: UIButton) {
        guard let emailText = self.emailTextField.text, emailText != "", isValidEmail(testStr: emailText) == true else {
            self.showErrorView(title: nil, message: nil, errorType: .emailError)
            return
        }
        guard let passwordText = self.passwordTextField.text, passwordText != "" else {
            self.showErrorView(title: nil, message: nil, errorType: .passwordError)
            return
        }
        ZVProgressHUD.maskType = .custom(color: UIColor.lightGray.withAlphaComponent(0.20))
        ZVProgressHUD.minimumDismissTimeInterval = 0.4
        ZVProgressHUD.displayStyle = .custom(backgroundColor: .white, foregroundColor: .black)
        ZVProgressHUD.show(with: "Login In..", in: self.view, delay: 0.0)
        
        Channelize.login(username: emailText, password: "123456", completion: {[weak self](user,error) in
            guard error == nil else{
                print(error?.localizedDescription)
                ZVProgressHUD.showError()
                return
            }
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
                navigationController.setNavigationBarHidden(true, animated: false)
                ZVProgressHUD.showSuccess()
                CHMain.launchApp(navigationController: navigationController, data: nil)
            }
        })
    }
    
    private func showErrorView(title: String?, message: String?, errorType: NormalUserSignUpError){
        
        var errorMessage = ""
        
        switch errorType {
        case .emailError:
            errorMessage = "Please enter a valid email address."
            break
        case .passwordError:
            errorMessage = "Please enter passowrd."
            break
        case .apiError:
            errorMessage = message ?? ""
            break
        }
        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
