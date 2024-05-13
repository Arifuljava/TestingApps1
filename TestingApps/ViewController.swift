//
//  ViewController.swift
//  TestingApps
//
//  Created by sang on 13/5/24.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    private let splashImageView = UIImageView()
        private let appNameLabel = UILabel()
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Start the timer
               startTimer()
       
        
    }
    private func configureView() {
           
           view.backgroundColor = .systemTeal
           
           
        splashImageView.image = UIImage(named: "cafe")
        splashImageView.contentMode = .scaleAspectFit
        view.addSubview(splashImageView)
        splashImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.widthAnchor.constraint(equalToConstant: 300),
            splashImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
           
           // Add app name label
           appNameLabel.text = "Grozziie"
           appNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
           appNameLabel.textColor = .white
           view.addSubview(appNameLabel)
           appNameLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               appNameLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
           ])
       }
    private func startTimer() {
           timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
               self.navigateToNextViewController()
           }
       }
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
       private func navigateToNextViewController() {
           if let user = Auth.auth().currentUser {
                  // User is logged in
               //logoutUser()
               let tabBarController = HomeViewController()
               tabBarController.modalPresentationStyle = .fullScreen
               self.present(tabBarController, animated: true)
               
                  print("User is logged in with email: \(user.email ?? "Unknown")")
              } else {
                  let tabBarController = LoginPageController()
                  tabBarController.modalPresentationStyle = .fullScreen
                  present(tabBarController, animated: true)
                  print("User is not logged in")
              }
           // Assuming you have a tab bar controller as the next view controller
          /*
           let tabBarController = LoginPageController()
           tabBarController.modalPresentationStyle = .fullScreen
           present(tabBarController, animated: true)
           */
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
           // Invalidate the timer when the view disappears
           timer?.invalidate()
           timer = nil
       }

}

