# Biometric Authentication Demo

This project demonstrates how to implement biometric authentication (Face ID/Touch ID) in an iOS app using the `LocalAuthentication` framework. It includes a **native SDK** for biometric authentication and a **demo app** that integrates the SDK.

---

## Table of Contents
1. [Features](#features)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Code Structure](#code-structure)
6. [Testing](#testing)

---

## Features
- **Biometric Authentication**: Uses Face ID or Touch ID to authenticate users.
- **Token Generation**: Generates a time-bound, device-bound token after successful authentication.
- **Backend Integration**: Sends the email and token to a backend server for validation.
- **MVC Architecture**: Follows the Model-View-Controller pattern for clean and maintainable code.

---

## Requirements
- **Xcode**: 12 or later.
- **iOS Device**: iPhone or iPad with Face ID or Touch ID (simulator does not support biometric authentication).
- **Python**: For running the Flask backend (optional).

---

## Installation
1. **Clone the Repository**:
   ```bash
   git clone "https://github.com/Chandrashekhar5/BiometricAuthApp.git"
2. **open the Project in Xcode**: 
     - Open BioMetricAuthApp.xcodeproj in folder
3. **Run the Flask Backend**:
     - Navigate to the backend folder:
       - cd backend
       - pip install Flask
       - python app.py

## Usage

### Run the Demo App:
1. Connect your iOS device to your Mac.
2. Select your device as the target in Xcode.
3. Click the **Run** button (or press `Cmd + R`).

### Enter Your Email:
- Enter your email address in the text field.

### Authenticate:
- Tap the **Submit** button.
- Authenticate using Face ID or Touch ID.

### View the Result:
- If authentication is successful, the app will send the email and token to the backend and display a success message.
- If authentication fails, the app will display an error message.

---

## Code Structure
The project is structured using the **MVC (Model-View-Controller)** pattern:

### 1. Model (`BiometricAuthModel.swift`)
Handles biometric authentication, token generation, and network requests.

### 2. View (`Main.storyboard`)
Contains the UI components:
- `emailTextField`: For entering the email address.
- `feedbackLabel`: For displaying authentication status.
- `submitButton`: For triggering the authentication process.

### 3. Controller (`ViewController.swift`)
Acts as the intermediary between the `Model` and the `View`.

---

## Testing

### Test Biometric Authentication:
1. Run the app on a physical device with Face ID or Touch ID.
2. Verify that the biometric prompt appears and authentication works.

### Test Backend Integration:
1. Run the Flask backend.
2. Verify that the app sends the email and token to the backend and receives a response.

### Test Error Handling:
- Test scenarios like invalid email, expired token, and untrusted device.
