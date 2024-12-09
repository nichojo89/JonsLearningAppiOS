//
//  SignInScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//
import SwiftUI
import FirebaseAuth

struct SignInScreen : View {
    
    @ObservedObject private var viewmodel = SignInViewModel()
    @FocusState private var isPasswordFocused: Bool
    @State private var showForgotPasswordAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack{
                    Image("sign_in_bg")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        let logoHeight = geometry.size.height * 0.1
                        let verticleSpacing = geometry.size.height * 0.01
                        
                        VStack {
                            ScrollView {
                                VStack(spacing: verticleSpacing) {
                                    Text("Welcome Back")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .font(.system(size: 32,weight: .bold))
                                        .frame(maxHeight: .infinity)
                                    Text("Enter your details below")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                        .padding(.top,2)
                                        .padding(.bottom,8)
                                        .frame(maxHeight: .infinity)
                                    Spacer()
                                    CustomTextField(title: "Username", text: $viewmodel.username, onEditingChanged: {
                                        (focused) in
                                        if !focused {
                                            viewmodel.emailErrorMessage = !viewmodel.username.isValidEmail() && !viewmodel.username.isEmpty  ? "Invalid email" : ""
                                            viewmodel.validateCredentials()
                                        }
                                    })
                                    
                                    Text(viewmodel.emailErrorMessage)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                        .padding(.bottom, 6)
                                    
                                    CustomSecureField(title: "Password", text: $viewmodel.password)
                                        .onChange(of: viewmodel.password) {
                                            viewmodel.validateCredentials()
                                        }
                                        .focused($isPasswordFocused)
                                        .autocorrectionDisabled(true)
                                        
                                    Text(viewmodel.passwordErrorMessage)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                        
                                    Button {
                                        if(viewmodel.username.isValidEmail()){
                                            viewmodel.emailErrorMessage = ""
                                            viewmodel.sendForgotPassword()
                                        } else {
                                            viewmodel.emailErrorMessage = "Invalid email"
                                        }
                                    } label: {
                                        Text("Forgot Password")
                                    }
                                    .frame(maxWidth: .infinity, alignment: Alignment.leading)
                                    .foregroundColor(Color(hex: 0xFFAD3689))
                                    .font(.system(size: 16, weight: .bold))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 0)
                                    .padding(.bottom, 6)
                                    .alert(viewmodel.forgotPasswordMessage, isPresented: $viewmodel.showForgotPasswordMessage) {
                                        Button("OK", role: .cancel){}
                                    }

                                    
                                    VStack(spacing: verticleSpacing) {
                                        ZStack{
                                            Divider()
                                                .padding(.top,4)
                                            Text("or sign in with")
                                                .padding(.horizontal,12)
                                                .foregroundColor(.gray)
                                                .background(.white)
                                        }
                                        .frame(maxHeight: .infinity)
                                        
                                        Button {
                                            Task {
                                                do {
                                                    try await FirebaseAuthenticator.googleOauth() { success in
                                                        if success {
                                                            viewmodel.navigateToDashboard = true
                                                        } else {
                                                            viewmodel.passwordErrorMessage = "Google sign in failed"
                                                        }
                                                    }
                                                } catch AuthenticationError.runtimeError(let errorMessage) {
                                                    let err = errorMessage
                                                    print(err)
                                                }
                                            }
                                        } label: {
                                            VStack {
                                                Image("ic_google")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .clipped()
                                                    .padding(10)
                                                    
                                                    .frame(width: 60, height: 60)
                                            }.frame(maxWidth: .infinity)
                                            
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(.gray, lineWidth: 1)
                                        )
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity, maxHeight: 60)
                                        
                                        Spacer()
                                            .frame(maxHeight: .infinity)
                                    }
                                    .frame(maxHeight: .infinity)
                                    
                                    Spacer()
                                        .frame(maxHeight: .infinity)
                                    HStack{
                                        Text("Need an account?")
                                            .foregroundColor(.black)
                                            .font(.system(size: 16))
                                            .multilineTextAlignment(.center)
                                        Button {
                                            viewmodel.navigateToCreateAccount = true
                                        } label: {
                                            Text("Create Account")
                                        }
                                        .foregroundColor(Color(hex: 0xFFAD3689))
                                        .font(.system(size: 16, weight: .bold))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 0)
                                    }
                                        
                                    Button {
                                        viewmodel.signIn()
                                    } label: {
                                        Text("Sign in")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .disabled(viewmodel.isSigninDisabled)
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.capsule)
                                    
                                }
                                .frame(alignment: Alignment.bottom)
                                .padding(20)
                            }
                            
                        }
                        .background(.white)
                        .clipShape(RoundedRectangle(
                            cornerRadius: 24,
                            style: .continuous
                        ))
                        .padding(.top, 30)
                        .frame(alignment: Alignment.bottom)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment.bottom)
                    
                }
                .navigationDestination(isPresented: $viewmodel.navigateToCreateAccount) {
                    if viewmodel.navigateToCreateAccount {
                        SignUpScreen()
                    }
                }
                .navigationDestination(isPresented: $viewmodel.navigateToDashboard){
                    if viewmodel.navigateToDashboard {
                        DashboardScreen()
                    }
                }
            }
        }
    }
    
}

#Preview {
    SignInScreen()
}
