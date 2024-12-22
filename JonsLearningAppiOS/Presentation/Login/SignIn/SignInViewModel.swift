//
//  SignInViewModel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//

import Foundation

class SignInViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isSigninDisabled: Bool = true
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var navigateToDashboard: Bool = false
    @Published var navigateToCreateAccount: Bool = false
    @Published var showForgotPasswordMessage: Bool = false
    @Published var forgotPasswordMessage: String = ""
    @Published var rememberMe: Bool = true
    
    func validateCredentials() {
        isSigninDisabled =  !username.isValidEmail() || password.isEmpty
    }
    
    func signIn() {
        FirebaseAuthenticator.signIn(email: username, password: password)
    }
    
    func sendForgotPassword(){
        FirebaseAuthenticator.sendForgotPassword(email: username) { success in
            if success {
                self.forgotPasswordMessage = "Password recovery email sent!"
            } else {
                self.forgotPasswordMessage = "Failed to send password recovery"
            }
            self.showForgotPasswordMessage = true
        }
    }
}
