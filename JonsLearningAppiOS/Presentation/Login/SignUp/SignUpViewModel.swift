//
//  SignUpViewModel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//

import Foundation
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isSignupDisabled: Bool = true
    @Published var isPasswordSecure: Bool = true
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var navigateToEmailVerification: Bool = false
    
    func showEmailVerification() -> Bool {
        if !FirebaseAuthenticator.authUser!.isEmailVerified {
            navigateToEmailVerification = true
            return true
        } else {
            //user should sign in or forgot password
            return false
        }
    }
    
    func validateCredentials() {
        let shouldShowPasswordMismatch = !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword
        
        isSignupDisabled = !username.isValidEmail() || password.isEmpty || confirmPassword.isEmpty || shouldShowPasswordMismatch
        
        if shouldShowPasswordMismatch {
            confirmPasswordErrorMessage = "Passwords do not match"
        } else {
            confirmPasswordErrorMessage = ""
        }
    }
    
    func showAuthError(authErrorCode : AuthErrorCode){
        switch authErrorCode {
        case .emailAlreadyInUse:
            if !showEmailVerification() {
                emailErrorMessage = "Email already in use"
            }
            emailErrorMessage = ""
            passwordErrorMessage = ""
        case .invalidEmail:
            emailErrorMessage = "Invalid email"
            passwordErrorMessage = ""
        case .wrongPassword:
            passwordErrorMessage = "Incorrect password"
            emailErrorMessage = ""
        default:
            passwordErrorMessage = "unknown error"
            emailErrorMessage = ""
        }
    }
    
    
    
    func signUp(){
        if(username.isValidEmail() && !password.isEmpty){
            isSignupDisabled = true
            FirebaseAuthenticator.register(email: username,password: password) { result in
                if result.success {
                    _ = self.showEmailVerification()
                } else {
                    if let err = result.errorCode {
                        self.showAuthError(authErrorCode: err)
                    }
                }
                self.isSignupDisabled = false
            }
        }
    }
}
