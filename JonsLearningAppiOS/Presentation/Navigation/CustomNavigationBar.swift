//
//  CustomNavigationBar.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/18/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    var title: String
    @Environment(\.presentationMode) var presentation
    
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
                // Add padding for status bar
                Color.clear
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                
                // Navigation bar content
                ZStack {
                    // Back button aligned to left
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
                                self.presentation.wrappedValue.dismiss()
                            }
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .zIndex(1) // Ensure back button is on top
                    
                    // Title centered
                    Text(title)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 44) // Fixed navigation bar height
                .padding(.bottom, 4)
            }
        }
        .frame(height: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 48) // Total height: status bar + nav bar
    }
}
#Preview {
    CustomNavigationBar(title: "Title")
}
