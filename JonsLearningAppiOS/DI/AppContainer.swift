//
//  AppContainer.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/22/24.
//

import Swinject
import SwiftUI

class NavigationState: ObservableObject {
    @Published var path = NavigationPath()
}

// AppContainer.swift
class AppContainer {
    static let shared = AppContainer()
    private var container: Container
    
    private init() {
        container = Container()
        
        // Register NavigationState as a singleton
        container.register(NavigationState.self) { _ in
            return NavigationState()
        }.inObjectScope(.container)  // Changed to singleton
        
        container.register(TokenManager.self) { _ in
            TokenManager()
        }
        
        // Remove NavigationPath registration since we're using NavigationState
        
        container.register(FirebaseAuthenticator.self) { resolver in
            let tokenManager = resolver.resolve(TokenManager.self)!
            return FirebaseAuthenticator(tokenManager: tokenManager)
        }
        
        container.register(SignInViewModel.self) { resolver in
            let authenticator = resolver.resolve(FirebaseAuthenticator.self)!
            let navigationState = resolver.resolve(NavigationState.self)!  // Changed to let
            return SignInViewModel(authenticator: authenticator, navigationState: navigationState)
        }
        
        container.register(SignUpViewModel.self) { resolver in
            let authenticator = resolver.resolve(FirebaseAuthenticator.self)!
            let navigationState = resolver.resolve(NavigationState.self)!  // Changed to let
            return SignUpViewModel(authenticator: authenticator, navigationState: navigationState)
        }
        
        container.register(EmailVerificationViewModel.self) { resolver in
            let authenticator = resolver.resolve(FirebaseAuthenticator.self)!
            return EmailVerificationViewModel(authenticator: authenticator)
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
