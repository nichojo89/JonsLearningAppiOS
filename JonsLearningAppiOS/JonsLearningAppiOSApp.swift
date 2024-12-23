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
    @State private var isLoggedIn = false
    @StateObject private var navigationState = AppContainer.shared.resolve(NavigationState.self)!
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationState.path) {
                if isLoggedIn {
                    DashboardScreen()
                        .navigationDestination(for: String.self) { destination in
                            if destination == NavigationDestination.signUp {
                                SignUpScreen()
                            }
                        }
                } else {
                    SignInScreen()
                        .navigationDestination(for: String.self) { destination in
                            if destination == NavigationDestination.signUp {
                                SignUpScreen()
                            } else if destination == NavigationDestination.dashboard {
                                DashboardScreen()
                            }
                        }
                }
            }
            .environmentObject(navigationState)
        }
    }
}
