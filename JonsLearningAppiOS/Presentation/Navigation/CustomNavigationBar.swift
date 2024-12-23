//
//  CustomNavigationBar.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/18/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    var title: String
    var popToRoot = false
    @State private var navigationState: NavigationState = AppContainer.shared.resolve(NavigationState.self)!
    
    var body: some View {
        ZStack {
            Rectangle()
                       .fill(
                           LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.5647, green: 0.1765, blue: 0.4431), // Darker purple
                                Color(red: 0.7059, green: 0.2118, blue: 0.5569)   // Lighter purple
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
                                    .frame(width: 12, height: 24)
                                    .foregroundColor(.white)
                                    .padding(.leading,8)
                            }.onTapGesture {
                                if(popToRoot){
                                    navigationState.path.removeLast(navigationState.path.count)
                                } else {
                                    navigationState.path.removeLast()
                                }
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
        .frame(height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 48)
    }
}
#Preview {
    CustomNavigationBar(title: "Title", popToRoot: false)
}
