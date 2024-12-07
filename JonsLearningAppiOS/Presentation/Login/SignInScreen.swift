//
//  SplashScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/4/24.
//
import SwiftUI
import FirebaseAuth

struct SignInScreen : View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var confirmPasswordErrorMessage: String = ""
    @State private var passwordErrorMessage: String = ""
    @State private var emailErrorMessage: String = ""
    @State private var isSignupDisabled: Bool = true
    @FocusState private var isPasswordFocused: Bool
    @State private var navigateToEmailVerification: Bool = false
    @State private var isPasswordSecure: Bool = true
    @State private var isConfirmPasswordVisible: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("sign_in_bg")
                    .resizable()
                    .frame(width: .infinity, height: .infinity)
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image("jonsLearningAppLogo")
                        .resizable()
                        .frame(width: 160, height: 160)
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical, 100)
                    Text("Create your account")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .frame(alignment: .top)
                    TextField("Username", text: $username, onEditingChanged: { (focused) in
                        if !focused {
                            emailErrorMessage = !username.isValidEmail() ? "Invalid email" : ""
                            validateCredentials()
                        }
                    })
                    .background(.white)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled(true)
                    
                    Text(emailErrorMessage)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.bottom, 12)
                    
                    SecureField("Password", text: $password)
                        .onChange(of: password) {
                            validateCredentials()
                            isConfirmPasswordVisible = !password.isEmpty
                        }
                        .focused($isPasswordFocused)
                        .background(.black)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled(true)
                        
                    Text(passwordErrorMessage)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.bottom, 12)
                    if isConfirmPasswordVisible {
                        SecureField("Confirm password", text: $confirmPassword)
                            .onChange(of: confirmPassword) {
                                validateCredentials()
                            }
                            .focused($isPasswordFocused)
                            .background(.white)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled(true)
                        
                        Text(confirmPasswordErrorMessage)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .padding(.bottom, 32)
                    }
                    Spacer()
                    VStack {
                        Text("Already have an account? Sign in")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                            .padding(.bottom,32)
                            
                        Button {
                            signUp()
                        } label: {
                            Text("Sign up")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(isSignupDisabled)
                        .foregroundColor(Color(hex: 0xFFAD3689))
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .padding(.horizontal, 10)
                        
                    }
                    .frame(alignment: .trailing)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(30)
                
            }
            .navigationDestination(isPresented: $navigateToEmailVerification){
                if navigateToEmailVerification {
                    EmailVerificationScreen()
                }
            }
        }
    }
    
    func showEmailVerification() -> Bool {
        if !FirebaseAuthenticator.authUser!.isEmailVerified {
            navigateToEmailVerification = true
            return true
        } else {
            //user should sign in or forgot password
            return false
        }
    }
    
    func validateCredentials() {
        let shouldShowPasswordMismatch = !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword
        
        isSignupDisabled = !username.isValidEmail() || password.isEmpty || confirmPassword.isEmpty || shouldShowPasswordMismatch
        
        if shouldShowPasswordMismatch {
            confirmPasswordErrorMessage = "Passwords do not match"
        } else {
            confirmPasswordErrorMessage = ""
        }
    }
    
    func showAuthError(authErrorCode : AuthErrorCode){
        switch authErrorCode {
        case .emailAlreadyInUse:
            if !showEmailVerification() {
                emailErrorMessage = "Email already in use"
            }
            emailErrorMessage = ""
            passwordErrorMessage = ""
        case .invalidEmail:
            emailErrorMessage = "Invalid email"
            passwordErrorMessage = ""
        case .wrongPassword:
            passwordErrorMessage = "Incorrect password"
            emailErrorMessage = ""
        default:
            passwordErrorMessage = "unknown error"
            emailErrorMessage = ""
        }
    }
    
    
    
    func signUp(){
        if(username.isValidEmail() && !password.isEmpty){
            isSignupDisabled = true
            FirebaseAuthenticator.register(email: username,password: password) { result in
                if result.success {
                    _ = showEmailVerification()
                } else {
                    if let err = result.errorCode {
                        showAuthError(authErrorCode: err)
                    }
                }
                isSignupDisabled = false
            }
        }
    }
}

#Preview {
    SignInScreen()
}
