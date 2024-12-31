//
//  JonsLearningAppiOSApp.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/4/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct JonsLearningAppiOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var navigationState = AppContainer.shared.resolve(NavigationState.self)!
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isSignedIn")
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationState.path) {
                if isLoggedIn {
//                    DashboardScreen()
                    CharacterGenerationScreen()
                } else {
                    SignInScreen()
                }
            }
            .navigationBarBackButtonHidden(true)
            .environmentObject(navigationState)
        }
    }
}
