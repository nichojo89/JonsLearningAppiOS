//
//  SignInScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//
import SwiftUI

struct SignInScreen : View {
    @ObservedObject private var viewmodel: SignInViewModel
    @FocusState private var isPasswordFocused: Bool
    @State private var showForgotPasswordAlert: Bool = false
    
    init() {
        viewmodel = AppContainer.shared.resolve(SignInViewModel.self)!
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image("sign_in_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
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
                                    .foregroundColor(.red)
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
                                    .foregroundColor(.red)
                                    .font(.system(size: 16))
                                    
                                HStack(spacing: 0) {
                                    Toggle(isOn: $viewmodel.rememberMe) {
                                        EmptyView()
                                    }
                                    .toggleStyle(CustomCheckboxToggleStyle())

                                    Text("Remember me")
                                        .foregroundColor(Color(hex: 0xFFAD3689))
                                        .font(.system(size: 16, weight: .bold))
                                        .padding(.leading, 4)
                                        .onTapGesture{
                                            viewmodel.rememberMe.toggle()
                                        }
                                    Spacer()
                                    Button {
                                        if viewmodel.username.isValidEmail() {
                                            viewmodel.emailErrorMessage = ""
                                            viewmodel.sendForgotPassword()
                                        } else {
                                            viewmodel.emailErrorMessage = "Invalid email"
                                        }
                                    } label: {
                                        Text("Forgot Password")
                                            .foregroundColor(Color(hex: 0xFFAD3689))
                                            .font(.system(size: 16, weight: .bold))
                                            .lineLimit(1) // Ensures text stays on one line
                                    }
                                    .alert(viewmodel.forgotPasswordMessage, isPresented: $viewmodel.showForgotPasswordMessage) {
                                        Button("OK", role: .cancel) {}
                                    }
                                }
                                .frame(maxWidth: .infinity)

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
                                            await viewmodel.googleOAuth()
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
                                        viewmodel.navigationState.path.append(NavigationDestination.signUp)
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
                                        .padding()
                                        .foregroundColor(.white) // Ensure text is visible
                                }
                                .disabled(viewmodel.isSigninDisabled)
                                .background(
                                    viewmodel.isSigninDisabled
                                            ? LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(red: 0.8314, green: 0.5569, blue: 0.8431), // Very light purple
                                                    Color(red: 0.9059, green: 0.6824, blue: 0.9059)  // Softer light purple
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                            : LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(red: 0.5647, green: 0.1765, blue: 0.4431), // Darker purple
                                                    Color(red: 0.7059, green: 0.2118, blue: 0.5569)  // Lighter purple
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                )
                                .clipShape(Capsule()) 
                                
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
            .navigationDestination(for: String.self) { destination in
                switch(destination) {
                    case NavigationDestination.signUp:
                        SignUpScreen()
                    case NavigationDestination.dashboard:
                        DashboardScreen()
                        .navigationBarBackButtonHidden(true)
                    case NavigationDestination.emailVerification:
                        EmailVerificationScreen()
                    default:
                        EmptyView()
                }
            }
        }
    }
}

#Preview {
    SignInScreen()
}
