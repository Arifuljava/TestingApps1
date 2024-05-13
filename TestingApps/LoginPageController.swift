//
//  LoginPageController.swift
//  TestingApps
//
//  Created by sang on 13/5/24.
//

import UIKit
import FirebaseAuth
import  SPIndicator
import FirebaseCore
import FirebaseFirestore

class LoginPageController: UIViewController,UITextFieldDelegate {
 
    private let backgroundImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.image = UIImage(named: "bg")
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()
      
      private let profileImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.image = UIImage(named: "cafe")
          imageView.layer.cornerRadius = 75
          imageView.clipsToBounds = true
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()
      
      private let welcomeLabel: UILabel = {
          let label = UILabel()
          label.text = "Welcome back"
          label.textColor = .white
          label.font = UIFont.boldSystemFont(ofSize: 30)
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
      
      private let emailTextField: UITextField = {
          let textField = UITextField()
              textField.placeholder = "Email"
              textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
              textField.textColor = .white
              textField.borderStyle = .none
              textField.layer.borderWidth = 2
              textField.layer.borderColor = UIColor.white.cgColor
              textField.layer.cornerRadius = 2
              textField.autocapitalizationType = .none
              textField.textAlignment = .center
              textField.keyboardType = .emailAddress
              return textField
      }()
      
      private let passwordTextField: UITextField = {
          let textField = UITextField()
          textField.placeholder = "Password"
          textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
          textField.textColor = .white
          textField.borderStyle = .none
          textField.layer.borderWidth = 2
          textField.layer.borderColor = UIColor.white.cgColor
          textField.layer.cornerRadius = 2
          textField.autocapitalizationType = .none
          textField.textAlignment = .center
          textField.keyboardType = .emailAddress
          return textField
      }()
      
      private let signInButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("Sign In", for: .normal)
          button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
          button.setTitleColor(.black, for: .normal)
          button.backgroundColor = .white
          button.layer.cornerRadius = 2
          button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
          button.titleLabel?.text = button.titleLabel?.text?.uppercased()
          return button
      }()
      
      private let createAccountLabel: UILabel = {
          let label = UILabel()
          label.text = "Don't have an account? Create one"
          label.textColor = .white
          label.textAlignment = .center
          label.isUserInteractionEnabled = true
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
      
      private let errorLabel: UILabel = {
          let label = UILabel()
          label.textColor = .red
          label.numberOfLines = 0
          label.textAlignment = .center
          return label
      }()
    private let forgetPasswordLabel: UILabel = {
            let label = UILabel()
            label.text = "Forget Password"
            label.textColor = .white
            label.textAlignment = .right
            label.isUserInteractionEnabled = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
      // MARK: - Lifecycle
      override func viewDidLoad() {
          super.viewDidLoad()
          view.backgroundColor = .white
          title = "Login"
          
          setupViews()
          
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createAccountLabelTapped))
          createAccountLabel.addGestureRecognizer(tapGesture)
          //delegate
          
          emailTextField.delegate = self
          passwordTextField.delegate =  self
          
      }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         // Dismiss the keyboard when return key is pressed
        if textField == passwordTextField {
                   // If passwordTextField is active, move to confirmPasswordTextField
            passwordTextField.resignFirstResponder()
               } else if textField == emailTextField {
                   // If confirmPasswordTextField is active, dismiss the keyboard
                   emailTextField.resignFirstResponder()
               }
        
         return true
     }
      // MARK: - Actions
      @objc private func signInButtonTapped() {
          UIView.animate(withDuration: 0.2) {
              self.signInButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
          } completion: { _ in
              UIView.animate(withDuration: 0.2) {
                  self.signInButton.transform = .identity
              }
          }
          
          guard let email = emailTextField.text, let password = passwordTextField.text else { return }
          if email == nil || email.isEmpty == true || password == nil || password.isEmpty == true {
              SPIndicator.present(title: "Warning", message: "Email or Password is empty.", preset: .error, from: .bottom)
          }
          else {
              //
              self.showLoadingAlert()
              searchonuser(collectionName: "Password", documentID: "\(email)") { document in
                  if let document = document, let password_get = document.data()?["password"] as? String {
                      print("Password: \(password_get)")
                      if password_get == password {
                          Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
                              guard let self = self else { return }
                              
                              if let error = error {
                                  //self.errorLabel.text = error.localizedDescription
                                  self.dismissloading()
                                  SPIndicator.present(title: "Error", message: "\(error.localizedDescription)", preset: .error, from: .bottom)
                              } else {
                                  self.dismissloading()
                                  // Successfully signed in
                                  // You can navigate to another screen or perform any other action here
                                  print("User signed in: \(authResult?.user.email ?? "No email")")
                              }
                          }
                          
                      }
                      else {
                          self.dismissloading()
                          SPIndicator.present(title: "Error", message: "Password not matched", preset: .error, from: .bottom)
                      }
                  } else {
                      self.dismissloading()
                      SPIndicator.present(title: "Warning", message: "You are not a valid user.", preset: .error, from: .bottom)
                  }
              }
              
              //
              
          }
          
          
      }
      
      @objc private func createAccountLabelTapped() {
          let tabBarController = RegisterController()
          tabBarController.modalPresentationStyle = .fullScreen
          present(tabBarController, animated: true)
         
      }
      
      // MARK: - Helpers
      private func setupViews() {
          view.addSubview(backgroundImageView)
          NSLayoutConstraint.activate([
              backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
              backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
          ])
          
          view.addSubview(profileImageView)
          NSLayoutConstraint.activate([
              profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
              profileImageView.widthAnchor.constraint(equalToConstant: 150),
              profileImageView.heightAnchor.constraint(equalToConstant: 150)
          ])
          
          view.addSubview(welcomeLabel)
          NSLayoutConstraint.activate([
              welcomeLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
              welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
          ])
          
          let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,forgetPasswordLabel, signInButton, createAccountLabel, errorLabel])
          stackView.axis = .vertical
          stackView.spacing = 16
          stackView.translatesAutoresizingMaskIntoConstraints = false
          
          view.addSubview(stackView)
          NSLayoutConstraint.activate([
              stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 180),
              stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
              stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
          ])
          
          NSLayoutConstraint.activate([
              emailTextField.heightAnchor.constraint(equalToConstant: 50),
              passwordTextField.heightAnchor.constraint(equalToConstant: 50),
              forgetPasswordLabel.heightAnchor.constraint(equalToConstant: 50),
              signInButton.heightAnchor.constraint(equalToConstant: 50)
          ])
      }
    func searchonuser (collectionName: String, documentID: String, completion: @escaping (DocumentSnapshot?) -> Void)
    {
            let db = Firestore.firestore()
           let collectionRef = db.collection(collectionName)
        let documentRef = collectionRef.document(documentID)
        documentRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                    completion(nil)
                    return
                }
                
                if let document = document, document.exists {
                    completion(document)
                } else {
                    print("Document does not exist")
                    completion(nil)
                }
            }
    }
    func showLoadingAlert() {
        DispatchQueue.main.async {
            self.dismissLoadingAlert()
            let alertController = UIAlertController(title: "Login\nChecking user data.....", message: "\n\n", preferredStyle: .alert)
                    let indicator = UIActivityIndicatorView(style: .medium)
                    indicator.center = CGPoint(x: 135.0, y: 65.5)
                    indicator.color = .gray
                    indicator.startAnimating()
                    alertController.view.addSubview(indicator)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    var alertController: UIAlertController!
   private  var activityIndicator: UIActivityIndicatorView!
    func dismissLoadingAlert() {
        DispatchQueue.main.async {
            if let alertController = self.alertController, alertController.isBeingPresented {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    func dismissloading(){
        DispatchQueue.main.async {
            if let presentedViewController = self.presentedViewController {
                if presentedViewController.isKind(of: UIAlertController.self) {
                  
                    presentedViewController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }}
