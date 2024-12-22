//
//  CustomCheckboxToggleStyle.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/22/24.
//
import SwiftUI

struct CustomCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(Color(hex: 0xFFAD3689))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
