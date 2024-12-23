//
//  EmailVerificationScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/6/24.
//
import SwiftUI

struct EmailVerificationScreen: View {
    @ObservedObject private var viewmodel : EmailVerificationViewModel
    
    init() {
        viewmodel = AppContainer.shared.resolve(EmailVerificationViewModel.self)!
    }
    var body: some View {
        NavigationView {
            NavigatableView(title: "Verification"){
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Text("Email verification required")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding()
                        Text("Send email verification")
                        Spacer()
                        Image("ic_email_verification")
                            .resizable()
                            .frame(width: geometry.size.width / 3,height: geometry.size.width / 3)
                        Spacer()
                        Button {
                            viewmodel.sendVerificationEmail()
                        } label: {
                            Text("Sign up")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(false)
                        .background()
                        .foregroundColor(Color(hex: 0xFFAD3689))
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .padding(.bottom, 30)
                    }
                    .padding(16)
                    .navigationBarHidden(true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

//#Preview {
//    EmailVerificationScreen()
//}
