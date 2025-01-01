//
//  CharacterGenerationViewmodel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/1/25.
//
import SwiftUI

class CharacterGenerationViewmodel : ObservableObject {
    @Published var generatedImage: String = ""
    @Published var isImageSelected: Bool = false
    @Published var selectedImage: UIImage? = nil
    @Published var isGeneratedImage: Bool = false
    @Published var title: String = "Describe character"
    @Published var generateCharacterEnabled: Bool = false
    @Published var prompt: String = "Cyberpunk warrior, futuristic, sci fi, bearded man"
}
