//
//  EmailVerificationViewModel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//

import Foundation
import SwiftUI

class EmailVerificationViewModel: ObservableObject {
    private var authenticator: FirebaseAuthenticator
    @Published var sendEmailMessage = ""
    
    init(authenticator: FirebaseAuthenticator) {
        self.authenticator = authenticator
    }
    
    func sendVerificationEmail() {
        self.authenticator.sendVerificationEmail() { [weak self] message in
            DispatchQueue.main.async {
                self?.sendEmailMessage = message
            }
        }
    }
}
