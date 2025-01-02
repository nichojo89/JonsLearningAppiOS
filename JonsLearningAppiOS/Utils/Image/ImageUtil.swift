//
//  ImageUtil.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/1/25.
//
import UIKit
class ImageUtil {
    static func convertBase64StringToUIImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
            print("Error: Unable to decode Base64 string.")
            return nil
        }
        
        guard let image = UIImage(data: imageData) else {
            print("Error: Unable to create UIImage from data.")
            return nil
        }
        
        return image
    }
}
extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
