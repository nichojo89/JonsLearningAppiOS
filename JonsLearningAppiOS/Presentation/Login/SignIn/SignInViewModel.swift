//
//  SignInViewModel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//

import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    private let authenticator: FirebaseAuthenticator
    @Published var navigationState: NavigationState
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = true
    @Published var isSigninDisabled: Bool = true
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var forgotPasswordMessage: String = ""
    @Published var showForgotPasswordMessage: Bool = false
    
    init(authenticator: FirebaseAuthenticator, navigationState: NavigationState) {
        self.authenticator = authenticator
        self.navigationState = navigationState
    }
    
    func validateCredentials() {
        isSigninDisabled =  !username.isValidEmail() || password.isEmpty
    }
    
    func signIn() {
        self.passwordErrorMessage = ""
        self.authenticator.signIn(email: username, password: password){ success, emailVerified, error in
            if(success){
                if(emailVerified){
                    if(self.navigationState.path.count > 0){
                        self.navigationState.path.removeLast()
                    }
                    self.navigationState.path.removeLast()
                    //self.navigationState.path.append(NavigationDestination.dashboard)
                    self.navigationState.path.append(NavigationDestination.character_generation)
                } else {
                    self.navigationState.path.append(NavigationDestination.emailVerification)
                }
            } else {
                self.passwordErrorMessage = error ?? ""
            }
        }
    }
    
    func sendForgotPassword(){
        self.authenticator.sendForgotPassword(email: username) { success in
            if success {
                self.forgotPasswordMessage = "Password recovery email sent!"
            } else {
                self.forgotPasswordMessage = "Failed to send password recovery"
            }
            self.showForgotPasswordMessage = true
        }
    }
    
    @MainActor
    func googleOAuth() async {
        do {
            try await self.authenticator.googleOauth{ success in
                if success {
                    if(self.navigationState.path.count > 0){
                        self.navigationState.path.removeLast()
                    }
//                    self.navigationState.path.append(NavigationDestination.dashboard)
                    self.navigationState.path.append(NavigationDestination.character_generation)
                } else {
                    self.passwordErrorMessage = "Google sign in failed"
                }
            }
        } catch {
            
        }
    }
}
