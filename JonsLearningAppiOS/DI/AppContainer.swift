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
        
        container.register(NavigationState.self) { _ in
            return NavigationState()
        }.inObjectScope(.container)  // Changed to singleton
        
        container.register(TokenManager.self) { _ in
            TokenManager()
        }
        
        container.register(FirebaseAuthenticator.self) { resolver in
            let tokenManager = resolver.resolve(TokenManager.self)!
            return FirebaseAuthenticator(tokenManager: tokenManager)
        }
        container.register(Img2ImgUseCase.self) { resolver in
            let httpClient = resolver.resolve(HTTPClient.self)!
            return Img2ImgUseCaseImpl(httpClient: httpClient)
        }
        
        container.register(HTTPClient.self) { resolver in
            let authenticator = resolver.resolve(FirebaseAuthenticator.self)!
            return HTTPClient(authenticator: authenticator)
        }
        
        container.register(SignInViewModel.self) { resolver in
            let authenticator = resolver.resolve(FirebaseAuthenticator.self)!
            let navigationState = resolver.resolve(NavigationState.self)!
            return SignInViewModel(authenticator: authenticator, navigationState: navigationState)
        }
        
        container.register(SignUpViewModel.self) { resolver in
            let authenticator = resolver.resolve(FirebaseAuthenticator.self)!
            let navigationState = resolver.resolve(NavigationState.self)!
            return SignUpViewModel(authenticator: authenticator, navigationState: navigationState)
        }
        
        container.register(EmailVerificationViewModel.self) { resolver in
            let authenticator = resolver.resolve(FirebaseAuthenticator.self)!
            return EmailVerificationViewModel(authenticator: authenticator)
        }
        
        container.register(CharacterGenerationViewmodel.self) { resolver in
            let img2ImgUseCase = resolver.resolve(Img2ImgUseCase.self)!
            return CharacterGenerationViewmodel(img2ImgUseCase: img2ImgUseCase)
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
