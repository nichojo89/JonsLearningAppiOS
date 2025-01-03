//
//  SignUpViewModel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//

import Foundation
import FirebaseAuth
import SwiftUI

class SignUpViewModel: ObservableObject {
    private var authenticator: FirebaseAuthenticator
    
    @Published var navigationState: NavigationState
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isSignupDisabled: Bool = true
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var confirmPasswordErrorMessage: String = ""
    
    init(authenticator: FirebaseAuthenticator, navigationState: NavigationState) {
        self.authenticator = authenticator
        self.navigationState = navigationState
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
            emailErrorMessage = "Email already in use"
            passwordErrorMessage = ""
        case .invalidEmail:
            emailErrorMessage = "Invalid email"
            passwordErrorMessage = ""
        case .wrongPassword:
            passwordErrorMessage = "Incorrect password"
            emailErrorMessage = ""
        case .weakPassword:
            passwordErrorMessage = "Password not strong enough"
            emailErrorMessage = ""
        default:
            passwordErrorMessage = "unknown error"
            emailErrorMessage = ""
        }
    }
    
    
    
    func signUp(){
        if(username.isValidEmail() && !password.isEmpty){
            isSignupDisabled = true
            self.authenticator.register(email: username,password: password) { result in
                if result.success {
                    self.navigationState.path.append(NavigationDestination.emailVerification)
                } else {
                    if let err = result.errorCode {
                        self.showAuthError(authErrorCode: err)
                    }
                }
                self.isSignupDisabled = false
            }
        }
    }
    
    @MainActor
    func googleOAuth() async {
        do {
            try await self.authenticator.googleOauth{ success in
                if success {
                    self.navigationState.path.removeLast(self.navigationState.path.count)
                    //self.navigationState.path.append(NavigationDestination.dashboard)
                    self.navigationState.path.append(NavigationDestination.character_generation)
                } else {
                    self.passwordErrorMessage = "Google sign in failed"
                }
            }
        } catch {
            
        }
    }
}
