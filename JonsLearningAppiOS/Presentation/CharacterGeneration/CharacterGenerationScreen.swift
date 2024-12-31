//
//  CharacterGenerationScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/30/24.
//

import SwiftUI

struct CharacterGenerationScreen : View {
    var body: some View {
        @State var prompt: String = ""
        @State var title: String = "Describe character"
        @State var generateCharacterEnabled: Bool = false
        @State var isImageSelected: Bool = false
        @State var selectedImageUri: UIImage? = nil
        @State var isImageSet: Bool = false
        @State var generatedImage: String = ""
        @State var isGeneratedImage: Bool = false
        
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex:0xFF8A2BE2), Color(hex:0xFF9370DB), Color(hex:0xFF8A2BE2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    ImageUploader(
                        image: $selectedImageUri,
                        isImageSet: $isImageSet,
                        generatedImage: $generatedImage,
                        isGeneratedImage: $isGeneratedImage,
                        width: geometry.size.width
                    )
                    .onTapGesture {
                        isImageSelected.toggle()
                    }
                    
                    Text("Select an image to base your character from")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    DOSStyleOutlinedTextField(prompt: $prompt, title: title)
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle character generation logic
                    }) {
                        Text("Generate")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(generateCharacterEnabled ? Color.pink : Color.gray.opacity(0.6))
                            .cornerRadius(10)
                    }
                    .disabled(!generateCharacterEnabled)
                    .padding(.bottom, 50)
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
                
                if isImageSelected {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isImageSelected = false
                        }
                    
                    HStack(spacing: 16) {
                        CameraButton { newImage in
                            selectedImageUri = newImage
                            isImageSet = true
                            isImageSelected = false
                            isGeneratedImage = false
                        }
                        
                        GalleryButton { newImage in
                            selectedImageUri = newImage
                            isImageSet = true
                            isImageSelected = false
                            isGeneratedImage = false
                        }
                    }
                }
            }
        }
    }
}

struct DOSStyleOutlinedTextField: View {
    @Binding var prompt: String
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("PressStart2P-Regular", size: 12))
                .foregroundColor(.green)
                .padding(4)
                .background(Color.black)
                .border(Color.green, width: 2)
            
            TextField("", text: $prompt)
                .padding(8)
                .background(Color.black)
                .foregroundColor(.green)
                .font(.custom("PressStart2P-Regular", size: 14))
                .border(Color.green, width: 2)
                .cornerRadius(4)
        }
        .frame(height: .infinity)
    }
}

struct ImageUploader: View {
    @Binding var image: UIImage?
    @Binding var isImageSet: Bool
    @Binding var generatedImage: String
    @Binding var isGeneratedImage: Bool
    @State var width: CGFloat

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
            } else {
                ZStack {
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
        }
        .frame(height: width)
    }
}

struct CameraButton: View {
    var action: (UIImage?) -> Void

    var body: some View {
        Button(action: {
            // Camera handling code here
            action(nil)
        }) {
            Image(systemName: "camera")
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
}

struct GalleryButton: View {
    var action: (UIImage?) -> Void

    var body: some View {
        Button(action: {
            // Gallery handling code here
            action(nil)
        }) {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
}

#Preview {
    CharacterGenerationScreen()
}
