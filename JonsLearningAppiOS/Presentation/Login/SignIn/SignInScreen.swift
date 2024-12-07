//
//  SignInScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//
import SwiftUI

struct SignInScreen : View {
    var body: some View {
        NavigationStack {
            ZStack{
                Image("sign_in_bg")
                    .resizable()
                    .frame(width: .infinity, height: .infinity)
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
