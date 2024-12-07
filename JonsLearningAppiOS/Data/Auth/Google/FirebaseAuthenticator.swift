//
//  FirebaseAuthenticator.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/5/24.
//

import FirebaseAuth


class FirebaseAuthenticator {
    static let authUser = Auth.auth().currentUser
    
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
}
