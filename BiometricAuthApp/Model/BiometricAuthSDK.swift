//
//  BiometricAuthSDK.swift
//  BiometricAuthApp
//
//  Created by Chandu .. on 3/17/25.
//

import Foundation
import LocalAuthentication

public class BiometricAuthSDK {
    
    public static let shared = BiometricAuthSDK()
    
    private init() {}
    
    //Authenticates the user using Face ID or Touch ID.
    public func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access your account."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            completion(false)
        }
    }
    
    //Generates a time-bound, device-bound token.
    public func generateToken(userId: String, deviceId: String) -> String {
        let expiration = Date().addingTimeInterval(300) // Token expires in 5 minutes
        let token = "\(userId)|\(deviceId)|\(expiration.timeIntervalSince1970)"
        return token
    }
    
    //Sends the email and token to the backend for validation.
    func sendDataToBackend(email: String, token: String, completion: @escaping (Bool, String) -> Void) {
        
        //Use your computer's IP address inplace of 192.168.1.225
        guard let url = URL(string: "http://192.168.1.225:5000/authenticate") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let body: [String: Any] = ["email": email, "token": token]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, "Error creating JSON body: \(error.localizedDescription)")
            return
        }
        
        // Log the request
        print("Sending request to:", url)
        print("Request body:", body)
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Request failed with error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            // Parse the JSON response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let success = json["success"] as? Bool, let message = json["message"] as? String {
                        completion(success, message)
                    } else {
                        completion(false, "Invalid response format")
                    }
                } else {
                    completion(false, "Failed to parse JSON")
                }
            } catch {
                completion(false, "JSON parsing error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
