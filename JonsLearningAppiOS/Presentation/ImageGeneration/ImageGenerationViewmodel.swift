//
//  ImageGenerationViewmodel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/1/25.
//
import SwiftUI

class ImageGenerationViewmodel : ObservableObject {
    private var img2ImgUseCase: Img2ImgUseCase
    private var txt2ImgUseCase: Txt2ImgUseCase
    @Published var navigationState: NavigationState
    @Published var isImageSelected: Bool = false
    @Published var imageIsGenerated: Bool = false
    @Published var isLoading: Bool = false
    @Published var title: String = "Describe image"
    @Published var generateImageEnabled: Bool = true
    
    @Published var image: UIImage? = nil {
        didSet {
            enableImageGeneration()
        }
    }
    @Published var prompt: String = "Cyberpunk warrior, futuristic, sci fi, bearded man" {
        didSet {
            enableImageGeneration()
        }
    }
    
    init(navigationState: NavigationState, img2ImgUseCase: Img2ImgUseCase, txt2ImgUseCase: Txt2ImgUseCase){
        self.img2ImgUseCase = img2ImgUseCase
        self.txt2ImgUseCase = txt2ImgUseCase
        self.navigationState = navigationState
    }

    @MainActor
    func generateImage() async {
        self.generateImageEnabled = false
        self.isLoading = true
        
        do {
            if let img = self.image {
                let result = try await img2ImgUseCase.getImg2Img(image: img, prompt: self.prompt)
                try await handleGeneratedImage(result)
            } else {
                let result = try await txt2ImgUseCase.getTxt2Img(prompt: prompt, negativePrompt: "low resolution")
                try await handleGeneratedImage(result)
            }
        } catch {
            self.imageIsGenerated = false
        }
        self.isLoading = false
        self.enableImageGeneration()
    }

    @MainActor
    private func handleGeneratedImage(_ result: GenerateCharacterResponse?) async throws {
        if let firstImage = result?.images?.first {
            let img = ImageUtil.convertBase64StringToUIImage(firstImage)
            self.image = img
            self.imageIsGenerated = true
        } else {
            self.imageIsGenerated = false
        }
    }

    
    func imageSelect(){
        if imageIsGenerated {
            self.navigationState.path.append(NavigationDestination.image_preview)
        } else {
            isImageSelected.toggle()
        }
    }
    
    private func enableImageGeneration() {
        DispatchQueue.main.async {
            self.generateImageEnabled = !(self.prompt.isEmpty && self.image == nil)
        }
    }
}
