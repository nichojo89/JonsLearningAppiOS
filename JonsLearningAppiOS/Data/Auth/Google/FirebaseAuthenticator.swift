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
    let authUser = Auth.auth().currentUser
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
                    let test = self.tokenManager.retrieveToken(forKey: "OAuthToken")
                }
                completion(FirebaseRegistrationResult(success: true, errorCode: nil))
            }
        }
    }
    
    //MARK: Send verification email to unverified users
    func sendVerificationEmail(){
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
    
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let err = error {
                //TODO handle error
            } else {
                self.authUser?.getIDToken() { idToken, error in
                    if let error = error {
                        // Handle error
                        return;
                    }
                    if let token = idToken {
                        self.tokenManager.storeToken(token, forKey: "OAuthToken")
                    }
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
    
}

enum AuthenticationError: Error {
    case runtimeError(String)
}
