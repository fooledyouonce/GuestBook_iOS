//  LoginViewController.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/1/21.

import SafariServices
import UIKit

class LoginViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    //text fields
    private let usernameEmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "email"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "event password"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        //~20min into 3rd video, explains adding borders
        return field
    }()
    
    //buttons
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("join event", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue //change to GB color
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("terms of service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("privacy policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("create event", for: .normal)
        return button
    }()
    
    //views
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "feather"))
        //~15min into 3rd video, explanation for another image view
        header.addSubview(backgroundImageView)
        return header
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        
        usernameEmailField.delegate = self
        passwordField.delegate = self
        addSubviews()
        view.backgroundColor = UIColor(named: "guestBookBG") //change to GB blue
    }
    
    override func viewDidLayoutSubviews() {
        //assign frames
        headerView.frame = CGRect(x: 0,
                                  y: 0.0,
                                  width: view.width,
                                  height: view.height/3.0)
        
        //idea: set headerview image to BG color of app, then overlay feather using instsgram
        //logo strategy from video 3
        
        usernameEmailField.frame = CGRect(x: 25,
                                  y: headerView.bottom + 40, //adjust distance from headerview
                                  width: view.width - 50,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 25,
                                  y: usernameEmailField.bottom + 10,
                                  width: view.width - 50,
                                  height: 52)
        
        loginButton.frame = CGRect(x: 25,
                                  y: passwordField.bottom + 10,
                                  width: view.width - 50,
                                  height: 52)
        
        createAccountButton.frame = CGRect(x: 25,
                                  y: loginButton.bottom + 10,
                                  width: view.width - 50,
                                  height: 50)
        
        termsButton.frame = CGRect(x: 10,
                                  y: view.height-view.safeAreaInsets.bottom - 100,
                                  width: view.width - 20,
                                  height: 52)
        
        privacyButton.frame = CGRect(x: 10,
                                  y: view.height-view.safeAreaInsets.bottom - 50,
                                  width: view.width - 20,
                                  height: 52)
        
        configureHeaderView()
    }
    private func configureHeaderView() {
        guard headerView.subviews.count == 1 else {
            return
        }
        guard var backgroundView = headerView.subviews.first else {
            return
        }
        backgroundView.frame = headerView.bounds
    }
    
    private func addSubviews() { //adds a bunch of subviews at once
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(createAccountButton)
        view.addSubview(headerView)
    }
    
    @objc private func didTapLoginButton() {
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
                  
                  return
              }
        //login functionality
        var username: String?
        var email: String?
        
        if usernameEmail.contains("@"), usernameEmail.contains(".") {
            //email
            email = usernameEmail
            //dismiss(animated: true, completion: nil) //comment this out to allow error alert to show
        }
        else {
            //username
            username = usernameEmail
        }
        AuthManager.shared.loginUser(username: username, email: email, password: password) { success in DispatchQueue.main.async {
                if success {
                    //user logged in
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    //error occurred
                    //this code is weird
                    let alert = UIAlertController(title: "join error", message: "unable to join event. please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } //not showing up, @8:15, go back and check to see if code is matching. Updated 12/08/21: seems to work w/line 180 commented out
            }
        }
    }
            
    @objc private func didTapTermsButton() { //create webpage
        guard let url = URL(string: "https://www.lipsum.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapPrivacyButton() { //create webpage
        guard let url = URL(string: "https://www.lipsum.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    @objc private func didTapCreateAccountButton() {
        let vc = RegistrationViewController()
        vc.title = "event homepage"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapLoginButton()
        }
            
        return true
    }
}
