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
    static let authUser = Auth.auth().currentUser
    
    //MARK: Register users with Firebase AD
    static func register(email: String, password: String, completion: @escaping(FirebaseRegistrationResult) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let err = error as NSError
                if let authErrorCode = AuthErrorCode(rawValue: err.code) {
                    completion(FirebaseRegistrationResult(success: false, errorCode: authErrorCode))
                }
            } else {
                completion(FirebaseRegistrationResult(success: true, errorCode: nil))
            }
        }
    }
    
    //MARK: Send verification email to unverified users
    static func sendVerificationEmail(){
        if let user = authUser {
            if !user.isEmailVerified {
                user.sendEmailVerification(completion: { (error) in
                    if error != nil {
                        //resend email UI
                    }
                })
            }
        }
    }
    
    static func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let err = error {
                let wtf = 0
            } else {
                authUser?.getIDToken() { idToken, error in
                    if let error = error {
                        // Handle error
                        return;
                    }
                    
                    var token = idToken
                    // Send token to your backend via HTTPS
                    // ...
                }
            }
        }
    }
    
    @MainActor
    static func googleOauth(completion: @escaping(Bool) -> Void) async throws {
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
            
            var token = idToken
            completion(true)
        }
    }
    
    static func sendForgotPassword(email: String, completion: @escaping(Bool) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error == nil)
        }
    }
    
    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
    
}

enum AuthenticationError: Error {
    case runtimeError(String)
}
