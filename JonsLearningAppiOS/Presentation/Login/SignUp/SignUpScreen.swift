//
//  SplashScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/4/24.
//

import SwiftUI

struct SignUpScreen : View {
    @ObservedObject private var viewmodel: SignUpViewModel
    @FocusState private var isPasswordFocused: Bool
    
    init(){
        viewmodel = AppContainer.shared.resolve(SignUpViewModel.self)!
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigatableView(title: "Sign up") {
                ZStack{
                    Image("sign_in_bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: .infinity, height: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        let verticleSpacing = geometry.size.height * 0.01
                        VStack {
                            //HERE
                            ScrollView {
                                VStack(spacing: verticleSpacing) {
                                    Text("Get Started")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .font(.system(size: 32,weight: .bold))
                                        .frame(maxHeight: .infinity)
                                    Text("Create your free account")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                        .padding(.top,2)
                                        .padding(.bottom,8)
                                        .frame(maxHeight: .infinity)
                                    ViewThatFits{
                                        Spacer()
                                        EmptyView()
                                    }
                                    CustomTextField(title: "Username", text: $viewmodel.username, onEditingChanged: {
                                        (focused) in
                                        if !focused {
                                            viewmodel.emailErrorMessage = !viewmodel.username.isValidEmail() && !viewmodel.username.isEmpty  ? "Invalid email" : ""
                                            viewmodel.validateCredentials()
                                        }
                                    })
                                    
                                    
                                    Text(viewmodel.emailErrorMessage)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                        .padding(.bottom, 6)
                                    
                                    CustomSecureField(title: "Password", text: $viewmodel.password)
                                        .onChange(of: viewmodel.password) {
                                            viewmodel.validateCredentials()
                                            viewmodel.isConfirmPasswordVisible = !viewmodel.password.isEmpty
                                        }
                                        .focused($isPasswordFocused)
                                        .autocorrectionDisabled(true)
                                        
                                    Text(viewmodel.passwordErrorMessage)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.black)
                                        .font(.system(size: 16))
                                        .padding(.bottom, 6)
                                    VStack {
                                        if viewmodel.isConfirmPasswordVisible {
                                            CustomSecureField(title: "Confirm password", text: $viewmodel.confirmPassword)
                                                .onChange(of: viewmodel.confirmPassword) {
                                                    viewmodel.validateCredentials()
                                                }
                                                .focused($isPasswordFocused)
                                                .autocorrectionDisabled(true)
                                            
                                            Text(viewmodel.confirmPasswordErrorMessage)
                                                .foregroundColor(.red)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .foregroundColor(.black)
                                                .font(.system(size: 16))
                                        }
                                    }.frame(maxHeight: .infinity)
                                    
                                    VStack(spacing: verticleSpacing) {
                                        ZStack{
                                            Divider()
                                                .padding(.top,4)
                                            Text("or sign up with")
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
                                        Text("Already have an account?")
                                            .foregroundColor(.black)
                                            .font(.system(size: 16))
                                            .multilineTextAlignment(.center)
                                        Text("Sign in")
                                            .foregroundColor(Color(hex: 0xFFAD3689))
                                            .font(.system(size: 16, weight: .bold))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 0)
                                            .onTapGesture {
                                                viewmodel.navigationState.path.removeLast()
                                            }
                                    }
                                    Button {
                                        viewmodel.signUp()
                                    } label: {
                                        Text("Sign up")
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .foregroundColor(.white)
                                    }
                                    .disabled(viewmodel.isSignupDisabled)
                                    .background(
                                        viewmodel.isSignupDisabled
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
                                    .padding(.horizontal)
                                    
                                }
                                .frame(alignment: Alignment.bottom)
                                .padding(20)
                            }
                        }
                        .padding(.top, 12)
                        .background(.white)
                        .frame(alignment: Alignment.bottom)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment.bottom)
                    
                }
                .navigationBarHidden(true)
                .navigationDestination(for: String.self){ destination in
                    switch(destination) {
                    case NavigationDestination.emailVerification:
                        EmailVerificationScreen()
                    case NavigationDestination.dashboard:
                        DashboardScreen()
                            .navigationBarBackButtonHidden(true)
                    case NavigationDestination.character_generation:
                        CharacterGenerationScreen()
                    default:
                        EmptyView()
                    }
                }
            }
            
        }.navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    SignUpScreen()
//}
