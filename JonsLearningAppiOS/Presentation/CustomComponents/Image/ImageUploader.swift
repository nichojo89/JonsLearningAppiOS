//
//  ImageUploader.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/1/25.
//
import SwiftUI

struct ImageUploader: View {
    @Binding var image: UIImage?
    @Binding var isImageSet: Bool
    @Binding var generatedImage: String
    @Binding var isGeneratedImage: Bool

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .cornerRadius(16)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex:0xFF8A2BE2), Color(hex:0xFF9370DB), Color(hex:0xFFBA55D3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    
                    .background(Color(hex:0xFF4B0082))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        Text("+")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.width)
    }
}
