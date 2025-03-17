//
//  ViewController.swift
//  BiometricAuthApp
//
//  Created by Chandu .. on 3/17/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackLabel.text = "Result: "
    }
    
    // MARK: - Actions
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.placeholder = "Please enter your email."
            return
        }
        emailTextField.resignFirstResponder()
        feedbackLabel.text = "Authenticating...."
        
        // Authenticate user using biometrics
        BiometricAuthSDK.shared.authenticateUser { success in
            if success {
                let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknownDevice"
                let token = BiometricAuthSDK.shared.generateToken(userId: email, deviceId: deviceId)
                
                // Send email and token to the backend
                self.sendEmailToBackend(email: email, token: token)
            } else {
                DispatchQueue.main.async {
                    self.feedbackLabel.textColor = UIColor.red
                    self.feedbackLabel.text = "Authentication failed."
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func sendEmailToBackend(email: String, token: String) {
        BiometricAuthSDK.shared.sendDataToBackend(email: email, token: token) { success, message in
            DispatchQueue.main.async {
                if success {
                    self.feedbackLabel.textColor = UIColor.green
                    self.feedbackLabel.text = "Authentication successful."
                } else {
                    self.feedbackLabel.textColor = UIColor.red
                    self.feedbackLabel.text = message
                }
            }
        }
    }
}
