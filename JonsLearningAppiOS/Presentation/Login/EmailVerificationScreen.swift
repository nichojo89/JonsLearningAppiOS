//
//  EmailVerificationScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/6/24.
//
import SwiftUI

struct EmailVerificationScreen: View {
    var body: some View {
        Button("Send email verification"){
            FirebaseAuthenticator.sendVerificationEmail()
        }
    }
}
