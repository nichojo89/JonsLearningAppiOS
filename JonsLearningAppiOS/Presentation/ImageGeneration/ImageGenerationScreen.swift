//
//  ImageGenerationScreen.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 12/30/24.
//

import SwiftUI
import Lottie

struct ImageGenerationScreen: View {
    @ObservedObject private var viewmodel: ImageGenerationViewmodel
    
    @State private var selectedImage: UIImage?
    @State private var isImageSet: Bool = false
    @State private var isCameraPresented = false
    @State private var isImagePickerPresented = false
    
    init() {
        viewmodel = AppContainer.shared.resolve(ImageGenerationViewmodel.self)!
    }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: 0xFFE0EAFC),
                    Color(hex: 0xFF9CFDEF3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                GeometryReader { geometry in
                    VStack {
                        ImageUploader(
                            image: $viewmodel.image,
                            isImageSet: $isImageSet,
                            isLoading: $viewmodel.isLoading,
                            isGeneratedImage: $viewmodel.imageIsGenerated
                        )
                        .onTapGesture {
                            if !viewmodel.isLoading {
                                viewmodel.imageSelect()
                            }
                        }
                        if(viewmodel.imageIsGenerated){
                            if let image = viewmodel.image {
                                ImageToolBar(image: image)
                            }
                            Spacer()
                        }

                        DOSStyleOutlinedTextField(prompt: $viewmodel.prompt, title: viewmodel.title)

                        Spacer()

                        Button {
                            Task {
                                await viewmodel.generateImage()
                            }
                        } label: {
                            Text("Generate")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                        }
                        .disabled(!viewmodel.generateImageEnabled)
                        .background(
                            !viewmodel.generateImageEnabled
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
                        viewmodel.image = newImage
                        isImageSet = true
                        viewmodel.isImageSelected = false
                        viewmodel.imageIsGenerated = false
                        isCameraPresented = true
                    }
                    Spacer()
                    GalleryButton { newImage in
                        viewmodel.image = newImage
                        isImageSet = true
                        viewmodel.isImageSelected = false
                        viewmodel.imageIsGenerated = false
                        isImagePickerPresented = true
                    }
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(isImagePickerPresented: $isImagePickerPresented) { image in
                self.viewmodel.image = image
                self.isImagePickerPresented = false
            }
        }
        .sheet(isPresented: $isCameraPresented) {
            CameraPicker(isCameraPresented: $isCameraPresented) { image in
                self.viewmodel.image = image
                self.isCameraPresented = false
            }
        }
        .onChange(of: viewmodel.image) { newValue, oldValue in
            if let img = viewmodel.image {
                selectedImage = img
            }
        }
        .navigationDestination(for: String.self) { destination in
            switch(destination) {
            case NavigationDestination.image_preview:
                if let image = self.selectedImage {
                    ImagePreviewScreen(image: image)
                }
                default:
                    EmptyView()
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
    ImageGenerationScreen()
}
