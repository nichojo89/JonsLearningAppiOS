//
//  ImagePreviewViewmodel.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/4/25.
//
import SwiftUI

class ImagePreviewViewmodel : ObservableObject {
    @Published var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
}
