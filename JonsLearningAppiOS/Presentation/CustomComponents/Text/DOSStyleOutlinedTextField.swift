//
//  DOSStyleOutlinedTextField.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/1/25.
//

import SwiftUI

struct DOSStyleOutlinedTextField: View {
    @Binding var prompt: String
    @State var height: CGFloat
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("PressStart2P-Regular", size: 12))
                .foregroundColor(.green)
                .padding(4)
                .background(Color.black)
                .border(Color.green, width: 2)
            
            ZStack(alignment: .topLeading) {
                // Placeholder if prompt is empty
                if prompt.isEmpty {
                    Text(prompt)
                        .foregroundColor(.green.opacity(0.5))
                        .font(.custom("PressStart2P-Regular", size: 14))
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                
                TextEditor(text: $prompt)
                    .padding(8)
                    .frame(height: height / 4)
                    .background(Color.black)
                    .foregroundColor(.green)
                    .font(.custom("PressStart2P-Regular", size: 14))
                    .border(Color.green, width: 2)
                    .cornerRadius(4)
                    .scrollContentBackground(.hidden)
            }
        }
    }
}
