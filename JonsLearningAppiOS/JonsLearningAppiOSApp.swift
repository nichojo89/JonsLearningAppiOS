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
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                DashboardScreen()
            } else {
                SignUpScreen()
            }
        }
    }
}
