//
//  EmailVerificationScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/6/24.
//
import SwiftUI

struct EmailVerificationScreen: View {
    @State private var toast: Toast? = nil
    @ObservedObject private var viewmodel: EmailVerificationViewModel
    
    init() {
        viewmodel = AppContainer.shared.resolve(EmailVerificationViewModel.self)!
    }
    
    var body: some View {
        NavigatableView(title: "Verification", popToRoot: true) {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Text("Email verification required")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .padding()
                    Text("Please verify email before signing in")
                    Spacer()
                    Image("ic_email_verification")
                        .resizable()
                        .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                    Spacer()
                    Button {
                        viewmodel.sendVerificationEmail()
                    } label: {
                        Text("Sign up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                    }
                    .disabled(false)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.5647, green: 0.1765, blue: 0.4431), // Darker purple
                                Color(red: 0.7059, green: 0.2118, blue: 0.5569)  // Lighter purple
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .padding(.bottom, 30)
                    .padding(.horizontal)
                }
                .padding(16)
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .toastView(toast: $toast)
        .onChange(of: viewmodel.sendEmailMessage) { newMessage in
            if !newMessage.isEmpty {
                toast = Toast(style: .success, message: newMessage)
            }
        }
    }
}

//#Preview {
//    EmailVerificationScreen()
//}
