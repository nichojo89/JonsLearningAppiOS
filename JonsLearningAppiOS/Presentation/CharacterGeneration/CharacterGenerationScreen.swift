//
//  CharacterGenerationScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/30/24.
//

import SwiftUI

struct CharacterGenerationScreen: View {
    @ObservedObject private var viewmodel: CharacterGenerationViewmodel
    
    @State private var isImageSet: Bool = false
    @State private var isCameraPresented = false
    @State private var isImagePickerPresented = false
    
    init() {
        viewmodel = AppContainer.shared.resolve(CharacterGenerationViewmodel.self)!
    }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: 0xFF8A2BE2), Color(hex: 0xFF9370DB), Color(hex: 0xFF8A2BE2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                GeometryReader { geometry in
                    let screenHeight = geometry.size.height > 0 ? geometry.size.height : 600

                    VStack {
                        ImageUploader(
                            height: screenHeight,
                            image: $viewmodel.selectedImage,
                            isImageSet: $isImageSet,
                            generatedImage: $viewmodel.generatedImage,
                            isGeneratedImage: $viewmodel.isGeneratedImage
                        )
                        .onTapGesture {
                            viewmodel.isImageSelected.toggle()
                        }

                        Text("Select an image to base your character from")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                            .multilineTextAlignment(.center)

                        Spacer()

                        DOSStyleOutlinedTextField(prompt: $viewmodel.prompt, height: screenHeight, title: viewmodel.title)

                        Spacer()

                        Button {
                            //TODO Generate image
                        } label: {
                            Text("Generate")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                        }
                        .disabled(!viewmodel.generateCharacterEnabled)
                        .background(
                            !viewmodel.generateCharacterEnabled
                                    ? LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.8314, green: 0.5569, blue: 0.8431), // Very light purple
                                            Color(red: 0.9059, green: 0.6824, blue: 0.9059)  // Softer light purple
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    : LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.5647, green: 0.1765, blue: 0.4431), // Darker purple
                                            Color(red: 0.7059, green: 0.2118, blue: 0.5569)  // Lighter purple
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                        )
                        .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxHeight: .infinity)
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            if viewmodel.isImageSelected {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewmodel.isImageSelected = false
                    }

                HStack(spacing: 16) {
                    Spacer()
                    CameraButton { newImage in
                        viewmodel.selectedImage = newImage
                        isImageSet = true
                        viewmodel.isImageSelected = false
                        viewmodel.isGeneratedImage = false
                        isCameraPresented = true
                    }
                    Spacer()
                    GalleryButton { newImage in
                        viewmodel.selectedImage = newImage
                        isImageSet = true
                        viewmodel.isImageSelected = false
                        viewmodel.isGeneratedImage = false
                        isImagePickerPresented = true
                    }
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(isImagePickerPresented: $isImagePickerPresented) { image in
                viewmodel.selectedImage = image
                isImagePickerPresented = false
            }
        }
        .sheet(isPresented: $isCameraPresented) {
            CameraPicker(isCameraPresented: $isCameraPresented) { image in
                viewmodel.selectedImage = image
                isCameraPresented = false
            }
        }
    }
}

struct CameraButton: View {
    var action: (UIImage?) -> Void

    var body: some View {
        Button(action: {
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
