//
//  SplashScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/4/24.
//
import SwiftUI

struct SignUpScreen : View {
    
    @ObservedObject private var viewmodel = SignUpViewModel()
    @FocusState private var isPasswordFocused: Bool
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack{
                    Image("sign_in_bg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: .infinity, height: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        
                        let logoHeight = geometry.size.height * 0.1
                        let verticleSpacing = geometry.size.height * 0.01
                        
                        Image("jonsLearningAppLogo")
                            .resizable()
                            .frame(width: logoHeight, height: logoHeight, alignment: Alignment.center)
                            .aspectRatio(contentMode: .fit)
                        
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
                                        
                                        HStack(spacing: 20) {
                                            Image("ic_google")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(10)
                                                .frame(width: 60, height: 60)
                                                .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(.gray, lineWidth: 1)
                                                    )
                                            Image("ic_facebook")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(10)
                                                .frame(width: 60, height: 60)
                                                .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(.gray, lineWidth: 1)
                                                    )
                                            Image("ic_linkedin")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(10)
                                                .frame(width: 60, height: 60)
                                                .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(.gray, lineWidth: 1)
                                                    )
                                        }
                                        .padding(.vertical,6)
                                        .frame(maxHeight: .infinity)
                                        
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
                                                //go back
                                            }
                                    }
                                        
                                    Button {
                                        viewmodel.signUp()
                                    } label: {
                                        Text("Sign up")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .disabled(viewmodel.isSignupDisabled)
//                                    .foregroundColor(Color(hex: 0xFFAD3689))
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
                        .frame(alignment: Alignment.bottom)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: Alignment.bottom)
                    
                }
                .navigationDestination(isPresented: $viewmodel.navigateToEmailVerification){
                    if viewmodel.navigateToEmailVerification {
                        EmailVerificationScreen()
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpScreen()
}
