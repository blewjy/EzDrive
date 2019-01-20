//
//  ViewController.swift
//  EzDrive
//
//  Created by Bryan Lew on 23/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()


        setupViews()
        
        setupSplashScreen()
        animateSplashScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Perform auto sign-in if the current user is still logged in
        if Auth.auth().currentUser != nil {
            let mainTabBarViewController = TabBarController()
            self.present(mainTabBarViewController, animated: true, completion: nil)
        }
    }
    
    let splashScreenView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = #imageLiteral(resourceName: "ezdrive_background")
            imageView.contentMode = .scaleAspectFill
            imageView.alpha = 1.0
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
   
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.frame
        
        return view
    }()

    func setupSplashScreen() {
        view.addSubview(splashScreenView)
        view.addSubview(logoImageView)
        
        splashScreenView.frame = view.frame
        logoImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 80).isActive = true
        logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        logoImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -80).isActive = true
    }
    
    func animateSplashScreen() {
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            UIView.animate(withDuration: 0.7) {
                self.splashScreenView.alpha = 0
            }
        }
    }

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ezdrive_background")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.7
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ezdrive_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loginTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.7)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.placeholder = "Password"
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 1, alpha: 0.7)])
        
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let loginIcon = UIImageView(image: #imageLiteral(resourceName: "ezdrive_user"))
        loginIcon.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let loginViewSeparator = UIView()
        loginViewSeparator.backgroundColor = .white
        loginViewSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        let passwordIcon = UIImageView(image: #imageLiteral(resourceName: "ezdrive_password"))
        passwordIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let passwordViewSeparator = UIView()
        passwordViewSeparator.backgroundColor = .white
        passwordViewSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginIcon)
        view.addSubview(loginViewSeparator)
        view.addSubview(passwordIcon)
        view.addSubview(passwordViewSeparator)
        
        loginIcon.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loginIcon.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loginIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loginIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        loginViewSeparator.topAnchor.constraint(equalTo: loginIcon.bottomAnchor, constant: 12).isActive = true
        loginViewSeparator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loginViewSeparator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loginViewSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        passwordIcon.topAnchor.constraint(equalTo: loginViewSeparator.bottomAnchor, constant: 16).isActive = true
        passwordIcon.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        passwordIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        passwordViewSeparator.topAnchor.constraint(equalTo: passwordIcon.bottomAnchor, constant: 8).isActive = true
        passwordViewSeparator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        passwordViewSeparator.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        passwordViewSeparator.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2.4
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleLogin() {
        Auth.auth().signIn(withEmail: self.loginTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            print("Login success!")
            let mainTabBarViewController = TabBarController()
            self.present(mainTabBarViewController, animated: true, completion: nil)
            self.loginTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        let buttonTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white])
        buttonTitle.append(NSAttributedString(string: "Sign up.", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white]))
        button.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
        button.setAttributedTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleSignUpButton() {
        let signUpViewController = SignUpViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let signUpNavController = UINavigationController(rootViewController: signUpViewController)
        present(signUpNavController, animated: true, completion: nil)
    }
    
    func setupViews() {
        // Set background image
        backgroundImageView.frame = view.frame
        backgroundImageView.addBlurEffect()
        view.addSubview(backgroundImageView)
        
        // Add subviews
        view.addSubview(inputsContainerView)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        // Add constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -120).isActive = true
        
        loginTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        loginTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 38).isActive = true
        loginTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        loginTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
            passwordTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 58.5).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 38).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
            passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 24).isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
}


