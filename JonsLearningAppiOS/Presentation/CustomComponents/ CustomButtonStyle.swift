//
//   CustomButtonStyle.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/7/24.
//

import SwiftUI

struct CustomButtonStyle: PrimitiveButtonStyle {
    @State var disabled = false
    @State var disabledColor: Color
    @State var enabledColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .background(disabled ? disabledColor : enabledColor)
    }
}
