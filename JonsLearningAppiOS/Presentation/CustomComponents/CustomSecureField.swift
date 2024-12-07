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
    
    var body: some View {
        ZStack(alignment: .leading) {
            SecureField("", text: $text)
                .padding(.leading)
                .frame(height: 55)
                .focused($isTyping)
                .background(isTyping ? .blue : Color.primary, in: RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 2))
            Text(title)
                .padding(.horizontal,5)
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
