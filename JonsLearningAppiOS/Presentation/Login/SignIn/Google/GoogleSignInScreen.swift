//
//  GoogleSignInScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/8/24.
//
import FirebaseAuth
import SwiftUI

struct GoogleSignInScreen: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)

        var body: some View {
            VStack {
                if userLoggedIn {
                    DashboardScreen()
                }
            }.onAppear{
                //Firebase state change listeneer
                Auth.auth().addStateDidChangeListener{ auth, user in
                    if (user != nil) {
                        userLoggedIn = true
                    } else {
                        userLoggedIn = false
                    }
                }
            }
        }
}
