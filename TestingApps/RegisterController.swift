//
//  RegisterController.swift
//  TestingApps
//
//  Created by sang on 13/5/24.
//

import UIKit
import FirebaseAuth
import  SPIndicator
import FirebaseCore
import FirebaseFirestore


class RegisterController: UIViewController, UITextFieldDelegate {
    private let backgroundImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.image = UIImage(named: "bg")
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let nameextField: UITextField = {
        let textField = UITextField()
            textField.placeholder = "Name"
            textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
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
    private let numberTextField: UITextField = {
        let textField = UITextField()
            textField.placeholder = "Mobile No"
            textField.attributedPlaceholder = NSAttributedString(string: "Mobile No", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
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
    private let cnfpasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
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
        button.setTitle("Sign Up", for: .normal)
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
        label.text = "Already have account? Login."
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Registration"
        
        setupViews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createAccountLabelTapped))
        createAccountLabel.addGestureRecognizer(tapGesture)
        //
        emailTextField.delegate = self
        passwordTextField.delegate =  self
        cnfpasswordTextField.delegate = self
        nameextField.delegate =  self
        numberTextField.delegate = self
       
        //
        
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
        else if textField == cnfpasswordTextField {
            // If confirmPasswordTextField is active, dismiss the keyboard
            cnfpasswordTextField.resignFirstResponder()
        }
        else if textField == nameextField {
            // If confirmPasswordTextField is active, dismiss the keyboard
            nameextField.resignFirstResponder()
        }
        else if textField == numberTextField {
            // If confirmPasswordTextField is active, dismiss the keyboard
            numberTextField.resignFirstResponder()
        }
        
         return true
     }
    private func passwordsMatch() -> Bool {
            return passwordTextField.text == cnfpasswordTextField.text
        }
    @objc private func signInButtonTapped() {
        UIView.animate(withDuration: 0.2) {
            self.signInButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.signInButton.transform = .identity
            }
        }
        
        guard let email = emailTextField.text, let password = passwordTextField.text,let cnfpassword = cnfpasswordTextField.text,let name = nameextField.text,let number = numberTextField.text else { return }
        
        if email.isEmpty  == true || password.isEmpty  == true || cnfpassword.isEmpty  == true  || name.isEmpty  == true  || number.isEmpty  == true  {
            SPIndicator.present(title: "Warning", message: "Enter all information.", preset: .error, from: .bottom)
            
        }
        else {
            //
            if !passwordsMatch(){
                SPIndicator.present(title: "Error", message: "Password is not matched", preset: .error, from: .bottom)
            }
            else {
                self.showLoadingAlert()
                let uuid = UUID()
                let user = UserModel(element: "User", name: name, email: email, password: password, number: number, uuid: uuid, time: Date())
                self.exsitsname(collectionName: "OldUser", documentID: email) { document in
                    if let document = document {
                        // Document exists
                        self.dismissloading()
                        SPIndicator.present(title: "Error", message: "Email Already exsist.", preset: .error, from: .bottom)
                       
                    } else {
                        // Document does not exist
                        self.signUpWithEmail(email: email , password: password) { result in
                            switch result {
                            case .success(let authResult):
                                // User signed up successfully
                                print("User signed up with email: \(authResult.user.email ?? "Unknown")")
                                let db = Firestore.firestore()
                                let olduserdata: [String: Any] = [
                                    "name": name,
                                    "number": number,
                                    // Add more fields as needed
                                ]
                                db.collection("OldUser").document(email).setData(olduserdata)
                                {
                                    error in
                                    if let error = error {
                                            print("Error adding document: \(error.localizedDescription)")
                                        self.dismissloading()
                                        SPIndicator.present(title: "Error", message: "Email Already exsist.", preset: .error, from: .bottom)
                                        } else {
                                            print("Document added successfully")
                                            //
                                            let passworddata: [String: Any] = [
                                                "password": password
                                            ]
                                            db.collection("Password").document(email).setData(passworddata)
                                            {  error in
                                                if let error = error {
                                                        print("Error adding document: \(error.localizedDescription)")
                                                    self.dismissloading()
                                                    SPIndicator.present(title: "Error", message: "Email Already exsist.", preset: .error, from: .bottom)
                                                } else {
                                                    print("Document added successfully")
                                                    //
                                                    let balanceinformation: [String: Any] = [
                                                        "mainbalance": "0",
                                                        "purchasebalance": "0",
                                                        "walletbalance": "0"
                                                    ]
                                                    db.collection("Mybalance").document(email).setData(balanceinformation)
                                                    {
                                                        error in
                                                            if let error = error {
                                                                    print("Error adding document: \(error.localizedDescription)")
                                                                self.dismissloading()
                                                                SPIndicator.present(title: "Error", message: "Email Already exsist.", preset: .error, from: .bottom)
                                                            } else {
                                                                let maindatas: [String: Any] = [
                                                                    "name": name,
                                                                    "email": email,
                                                                    "password": password,
                                                                    "number": number,
                                                                    "image": "0",
                                                                    "uuid": uuid.uuidString
                                                                ]
                                                                db.collection("User").document(email).setData(maindatas)
                                                                {
                                                                    error in
                                                                        if let error = error {
                                                                                print("Error adding document: \(error.localizedDescription)")
                                                                            self.dismissloading()
                                                                            SPIndicator.present(title: "Error", message: "Email Already exsist.", preset: .error, from: .bottom)
                                                                        } else {
                                                                            self.dismissloading()
                                                                            SPIndicator.present(title: "Done", message: "Registration successfully done.", preset: .done, from: .bottom)
                                                                            let tabBarController = HomeViewController()
                                                                            tabBarController.modalPresentationStyle = .fullScreen
                                                                            self.present(tabBarController, animated: true)
                                                                        }
                                                                }
                                                                
                                                                
                                                            }
                                                    }
                                                    //
                                                    
                                                }
                                            }
                                            //
                                        }
                                }
                                
                                
                                //
                                //
                                
                            case .failure(let error):
                                // An error occurred
                                self.dismissloading()
                                SPIndicator.present(title: "Error", message: " \(error.localizedDescription)", preset: .error, from: .bottom)
                                print("Sign up error: \(error.localizedDescription)")
                            }
                        }
                        
                        
                        // Document does not exist
                        
                    }
                }
                
                
            }
            //
        }
        
        
    }
    func signUpWithEmail(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                let error = NSError(domain: "com.grozziie.TestingApps", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected error occurred"])
                completion(.failure(error))
                return
            }
            
            completion(.success(authResult))
        }
    }
    func showLoadingAlert() {
        DispatchQueue.main.async {
            self.dismissLoadingAlert()
            let alertController = UIAlertController(title: "Registration\nStoring user data.....", message: "\n\n", preferredStyle: .alert)
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
    }
    //function
    func exsitsname (collectionName: String, documentID: String, completion: @escaping (DocumentSnapshot?) -> Void)
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
    //function
    @objc private func createAccountLabelTapped() {
        let tabBarController = LoginPageController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
       
    }
    private func setupViews() {
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
       
        view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [nameextField,numberTextField,emailTextField, passwordTextField,cnfpasswordTextField, signInButton, createAccountLabel, errorLabel])
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
            nameextField.heightAnchor.constraint(equalToConstant: 50),
            numberTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            cnfpasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
