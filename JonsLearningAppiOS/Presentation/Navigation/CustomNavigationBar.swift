//
//  CustomNavigationBar.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/18/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    var title: String
    @State private var navigationState: NavigationState = AppContainer.shared.resolve(NavigationState.self)!
    var body: some View {
        ZStack {
            Rectangle()
                       .fill(
                           LinearGradient(
                               gradient: Gradient(colors: [
                                   Color(red: 0.6, green: 0.2, blue: 0.6), // Darker purple
                                   Color(red: 0.8, green: 0.3, blue: 0.8)  // Lighter purple
                               ]),
                               startPoint: .leading,
                               endPoint: .trailing
                           )
                       )
            
            // Content
            VStack(spacing: 0) {
                Color.clear
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                ZStack {
                    HStack {
                        Button(action: {
                            if let presentationMode = UIApplication.shared.currentViewController?.navigationController?.viewControllers {
                                if presentationMode.count > 1 {
                                    UIApplication.shared.currentViewController?.navigationController?.popViewController(animated: true)
                                }
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 10, height: 15)
                                    .foregroundColor(.white)
                                Text("Back")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }.onTapGesture {
                                //TODO only pop to root if askedto
                                navigationState.path.removeLast()
                            }
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .zIndex(1)
                    
                    Text(title)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 44)
                .padding(.bottom, 4)
            }
        }
        .frame(height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 48) // Total height: status bar + nav bar
    }
}
//#Preview {
//    CustomNavigationBar(title: "Title")
//}
