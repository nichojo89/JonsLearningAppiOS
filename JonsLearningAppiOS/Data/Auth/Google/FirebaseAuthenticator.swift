//
//  FirebaseAuthenticator.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/5/24.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn


class FirebaseAuthenticator {
    var authUser = Auth.auth().currentUser
    private var tokenManager: TokenManager
    
    init(tokenManager: TokenManager) {
        self.tokenManager = TokenManager()
    }
    
    //MARK: Register users with Firebase AD
    func register(email: String, password: String, completion: @escaping(FirebaseRegistrationResult) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let err = error as NSError
                if let authErrorCode = AuthErrorCode(rawValue: err.code) {
                    completion(FirebaseRegistrationResult(success: false, errorCode: authErrorCode))
                }
            } else {
                if let token = authResult?.credential?.idToken {
                    self.tokenManager.storeToken(token, forKey: "OAuthToken")
                    self.authUser = Auth.auth().currentUser
                }
                completion(FirebaseRegistrationResult(success: true, errorCode: nil))
            }
        }
    }
    
    //MARK: Send verification email to unverified users
    func sendVerificationEmail(completion: @escaping(String) -> Void){
        if let user = authUser {
            if !user.isEmailVerified {
                user.sendEmailVerification(completion: { (error) in
                    if error != nil {
                        let firebaseError = self.getErrorDescription(error: error)
                        completion(firebaseError)
                    } else {
                        completion("Verification email sent")
                    }
                })
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping(Bool, Bool, String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let error  {
                let errorMessage = self.getErrorDescription(error: error)
                completion(false, true, errorMessage)
            } else {
                self.authUser = Auth.auth().currentUser
                if let user = self.authUser {
                    if(!user.isEmailVerified){
                        completion(true, false, nil)
                    } else {
                        user.getIDToken() { idToken, error in
                            if let error = error {
                                let errorMessage = self.getErrorDescription(error: error)
                                completion(false, true, errorMessage)
                            } else if let token = idToken {
                                _ = self.tokenManager.storeToken(token, forKey: "OAuthToken")
                                completion(true, true, nil)
                                return
                            } else {
                                completion(false, true, "Authentication failed")
                            }
                        }
                    }
                } else {
                    completion(false, true, "User not found")
                }
            }
        }
    }
    
    @MainActor
    func googleOauth(completion: @escaping(Bool) -> Void) async throws {
        // google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false)
            fatalError("no firbase clientID found")
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //get rootView
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = scene?.windows.first?.rootViewController
        else {
            completion(false)
            fatalError("There is no root view controller!")
        }
        
        //google sign in authentication response
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            completion(false)
            throw AuthenticationError.runtimeError("Unexpected error occurred, please retry")
        }
        
        //Firebase auth
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken, accessToken: user.accessToken.tokenString
        )
        try await Auth.auth().signIn(with: credential)
        authUser?.getIDToken() { idToken, error in
            if let error = error {
                completion(false)
                return;
            }
            
            if let token = idToken {
                self.tokenManager.storeToken(token, forKey: "OAuthToken")
                let test = self.tokenManager.retrieveToken(forKey: "OAuthToken")
            }
            completion(true)
        }
    }
    
    func sendForgotPassword(email: String, completion: @escaping(Bool) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error == nil)
        }
    }
    
    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
    
    func getErrorDescription(error: Error?) -> String {
        var errorMessage: String = ""
        if let error {
            let err = error as NSError
            let firebaseError = AuthErrorCode(rawValue: err.code)
            if let firebaseError {
                switch firebaseError.code {
                    case .wrongPassword:
                        errorMessage = "The password is incorrect"
                    case .invalidEmail:
                        errorMessage = "The email address is badly formatted"
                    case .userNotFound:
                        errorMessage = "No user found with this email address"
                    case .userDisabled:
                        errorMessage = "This account has been disabled"
                    case .networkError:
                        errorMessage = "Network error"
                    case .tooManyRequests:
                        errorMessage = "Too many requests!"
                    case .operationNotAllowed:
                        errorMessage = "Sign-in method is not enabled"
                    case .emailAlreadyInUse:
                        errorMessage = "The email address is already in use"
                    case .weakPassword:
                        errorMessage = "The password is too weak"
                    case .accountExistsWithDifferentCredential:
                        errorMessage = "An account already exists with the same email address but different sign-in credentials"
                    case .invalidCredential:
                        errorMessage = "The provided credentials are invalid"
                    case .requiresRecentLogin:
                        errorMessage = "Please sign in again."
                    case .invalidVerificationCode:
                        errorMessage = "The verification code is invalid"
                    default:
                        errorMessage = "An error occurred"
                }
            }
        }
        return errorMessage
    }
    
}

enum AuthenticationError: Error {
    case runtimeError(String)
}
