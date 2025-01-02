//
//  CharacterGenerationViewmodel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/1/25.
//
import SwiftUI

class CharacterGenerationViewmodel : ObservableObject {
    private var img2ImgUseCase: Img2ImgUseCase
    @Published var generatedImage: String = ""
    @Published var isImageSelected: Bool = false
    @Published var isGeneratedImage: Bool = false
    @Published var title: String = "Describe character"
    @Published var generateCharacterEnabled: Bool = false
    @Published var selectedImage: UIImage? = nil {
        didSet {
            enableCharacterGeneration()
        }
    }
    @Published var prompt: String = "Cyberpunk warrior, futuristic, sci fi, bearded man" {
        didSet {
            enableCharacterGeneration()
        }
    }
    
    init(img2ImgUseCase: Img2ImgUseCase){
        self.img2ImgUseCase = img2ImgUseCase
    }

    func generateCharacter() async throws {
        if let image = self.selectedImage {
            let result = try await img2ImgUseCase.getImg2Img(image: image, prompt: self.prompt)
            if let firstImage = result.images?.first {
                let img = ImageUtil.convertBase64StringToUIImage(firstImage)
                self.selectedImage = img
            } else {
                //TODO show error
            }
        } else {
            //TODO Txt2Img
        }
    }
    
    private func enableCharacterGeneration() {
        self.generateCharacterEnabled = !self.prompt.isEmpty || self.selectedImage != nil
    }
}
