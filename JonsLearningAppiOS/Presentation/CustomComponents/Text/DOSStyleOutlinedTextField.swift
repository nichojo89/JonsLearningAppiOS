//
//  DOSStyleOutlinedTextField.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/1/25.
//

import SwiftUI

struct DOSStyleOutlinedTextField: View {
    @Binding var prompt: String
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Font.system(size: 20, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(hex: 0xFF03001e),
                            Color(hex: 0xFF7303c0),
                            Color(hex: 0xFFec38bc)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.vertical,4)
            
            
            ZStack(alignment: .topLeading) {
                // Placeholder if prompt is empty
                if prompt.isEmpty {
                    Text(prompt)
                        .foregroundColor(.black.opacity(0.5))
                        .font(.custom("PressStart2P-Regular", size: 14))
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                
                TextEditor(text: $prompt)
                    
                    .padding(8)
                    .frame(height: UIScreen.main.bounds.height / 4)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .font(.custom("PressStart2P-Regular", size: 14))
                    .cornerRadius(16)
                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(hex: 0xFF03001e),
                                                    Color(hex: 0xFF7303c0),
                                                    Color(hex: 0xFFec38bc),
                                                    Color(hex: 0xFFfdeff9)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ), lineWidth: 4)
                                    )
                    .cornerRadius(16)
                    .scrollIndicators(.visible)
                    .scrollContentBackground(.visible)
            }
        }
    }
}
