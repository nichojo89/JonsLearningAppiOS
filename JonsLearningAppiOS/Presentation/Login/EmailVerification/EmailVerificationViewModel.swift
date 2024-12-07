//
//  EmailVerificationViewModel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//

import Foundation

class EmailVerificationViewModel: ObservableObject {
    
    func sendVerificationEmail(){
        FirebaseAuthenticator.sendVerificationEmail()
    }
}
