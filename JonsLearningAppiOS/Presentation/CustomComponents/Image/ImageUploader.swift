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
    @Binding var isLoading: Bool
    @Binding var isGeneratedImage: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        ZStack {
                            if isLoading {
                                AnimatedGIFView(gifName: "loading_animation")
                                    .frame(width: 150, height: 150)
                                    .opacity(1)
                            }
                        }
                    ).opacity(isLoading ? 0.8 : 1)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: 0xFF03001e),
                                Color(hex: 0xFF7303c0),
                                Color(hex: 0xFFec38bc),
                                Color(hex: 0xFFfdeff9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .background(Color(hex: 0xFFafc3e0))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        ZStack {
                            if isLoading {
                                AnimatedGIFView(gifName: "loading_animation")
                                    .frame(width: 150, height: 150)
                            } else {
                                Text("+")
                                    .font(.largeTitle)
                                    .foregroundColor(Color(hex: 0xFF3372cc))
                            }
                        }
                    )
            }
            
            if image != nil {
                CloseButton(image: $image, isGeneratedImage: $isGeneratedImage)
                    .padding(16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.width)
    }
}

struct CloseButton: View {
    @Binding var image: UIImage?
    @Binding var isGeneratedImage: Bool
    var body: some View {
        Button(action: {
            image = nil
            isGeneratedImage = false
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(Circle().fill(Color.black))
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        }.opacity(0.7)
    }
}

//struct ImageUploader_Previews: PreviewProvider {
//    static var previews: some View {
//        StatefulPreviewWrapper(UIImage(named: "jonsLearningAppLogo")) { image in
//            ImageUploader(
//                image: image,
//                
//                isImageSet: .constant(true),
//                isGeneratedImage: .constant(false)
//            )
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}
//
//struct StatefulPreviewWrapper<Value, Content: View>: View {
//    @State private var value: Value
//    private let content: (Binding<Value>) -> Content
//
//    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
//        _value = State(initialValue: initialValue)
//        self.content = content
//    }
//
//    var body: some View {
//        content($value)
//    }
//}
