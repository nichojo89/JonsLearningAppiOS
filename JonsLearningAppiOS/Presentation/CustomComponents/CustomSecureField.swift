//
//  CustomSecureField.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//

import SwiftUI

struct CustomSecureField: View {
    let title: String
    @Binding var text: String
    @FocusState var isTyping: Bool
    @State private var isSecured: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            Group {
                if isSecured {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
            .padding(.leading)
            .padding(.trailing, 40) // Make room for the eye icon
            .frame(height: 55)
            .focused($isTyping)
            .background(
                isTyping ? .blue : Color.primary,
                in: RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 2)
            )
            
            // Eye icon button
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: isSecured ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(isTyping ? .blue : .primary)
            }
            .padding(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            // Title label
            Text(title)
                .padding(.horizontal, 5)
                .background(.infoField.opacity(isTyping || !text.isEmpty ? 1 : 0))
                .foregroundStyle(isTyping ? .blue : Color.primary)
                .padding(.leading)
                .offset(y: isTyping || !text.isEmpty ? -27 : 0)
                .onTapGesture {
                    isTyping.toggle()
                }
        }
        .animation(.linear(duration: 0.2), value: isTyping)
    }
}
