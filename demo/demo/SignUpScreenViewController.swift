//
//  SignUpScreenViewController.swift
//  demo
//
//  Created by Ashish-BigStep on 1/16/20.
//  Copyright © 2020 Channelize. All rights reserved.
//

import UIKit
import Channelize_API
import Alamofire
import ZVProgressHUD
import ZVActivityIndicatorView

class SignUpScreenViewController: UIViewController {

    private var displayNameField: UITextField = {
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
        textField.keyboardType = .namePhonePad
        textField.textContentType = UITextContentType(rawValue: "")
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 13.0
        textField.autocorrectionType = .no
        textField.setLeftPadding(withPadding: 20)
        textField.tintColor = .black
        textField.clearButtonMode = .whileEditing
        textField.inputAccessoryView = nil
        textField.defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.kern:1.5,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17.0, weight: .medium)]
        textField.attributedPlaceholder = NSAttributedString(string: "Display Name",attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.kern:1.5,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17.0, weight: .medium)])
        return textField
    }()
    
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
    
    private var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
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
    
    private var backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround(cancelTouchInView: false)
        self.view.backgroundColor = .white
        self.setUpViews()
        self.setUpViewsFrames()
        // Do any additional setup after loading the view.
    }
    

    private func setUpViews() {
        self.view.addSubview(displayNameField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(signUpButton)
        self.view.addSubview(backButton)
        self.signUpButton.addTarget(self, action: #selector(doSignUp(sender:)), for: .touchUpInside)
        self.backButton.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func setUpViewsFrames() {
        
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20)
        
        self.emailTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        self.emailTextField.widthAnchor.constraint(equalToConstant: 290).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        self.displayNameField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20).isActive = true
        self.displayNameField.widthAnchor.constraint(equalToConstant: 290).isActive = true
        self.displayNameField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.displayNameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.displayNameField.bottomAnchor, constant: 20).isActive = true
        self.passwordTextField.widthAnchor.constraint(equalToConstant: 290).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
        self.signUpButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30).isActive = true
        self.signUpButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }
    
    @objc private func doSignUp(sender: UIButton) {
        
        
        guard let emailText = self.emailTextField.text, emailText != "", isValidEmail(testStr: emailText) == true else {
            self.showErrorView(title: nil, message: nil, errorType: .emailError)
            return
        }
        guard let passwordText = self.passwordTextField.text, passwordText != "" else {
            self.showErrorView(title: nil, message: nil, errorType: .passwordError)
            return
        }
        
        var privateKey: String?
        
        if let path = Bundle.main.path(forResource: "Channelize-Info", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                privateKey = dict["PRIVATE_KEY"] as? String
            }
        }
        
        guard let data = privateKey?.data(using: String.Encoding.utf8) else {
            return
        }
        let authorization = data.base64EncodedString()
        var headers = [String : String]()
        headers.updateValue("application/json", forKey: "content-Type")
        headers.updateValue("Basic \(authorization)", forKey: "authorization")
        
        var params = [String : Any]()
        params.updateValue(self.displayNameField.text ?? "", forKey: "displayName")
        params.updateValue(emailText, forKey: "email")
        params.updateValue(passwordText, forKey: "password")
        
        ZVProgressHUD.maskType = .custom(color: UIColor.lightGray.withAlphaComponent(0.20))
        ZVProgressHUD.minimumDismissTimeInterval = 0.4
        ZVProgressHUD.displayStyle = .custom(backgroundColor: .white, foregroundColor: .black)
        ZVProgressHUD.show()
        let createUserUrl = "https://api.channelize.io/v1/users"
        Alamofire.request(createUserUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON(completionHandler: {[weak self](res ) in
            switch res.result{
            case .success(let value):
                ZVProgressHUD.showSuccess()
                self?.navigationController?.popViewController(animated: true)
                print(value)
                break
            case .failure(let error):
                print(error)
                ZVProgressHUD.showError()
                break
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
    
    @objc private func backButtonPressed(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
