//
//  Img2ImgUseCase.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/1/25.
//

import Foundation
import UIKit

protocol Img2ImgUseCase {
    func getImg2Img(image: UIImage, prompt: String) async throws -> GenerateCharacterResponse
}
class Img2ImgUseCaseImpl: Img2ImgUseCase {
    private var httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getImg2Img(image: UIImage, prompt: String) async throws -> GenerateCharacterResponse  {
        let url = self.httpClient.baseURL.appendingPathComponent("ImageToImage/GenerateCharacter")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let resizedImage = image.resizeImage(targetSize: CGSize(width: 1024, height: 1024))
        guard let imageData = resizedImage?.pngData() else {
            throw HTTPError.invalidImage
        }
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"prompt\"\r\n".data(using: .utf8)!)
        if !prompt.isEmpty {
            body.append("\r\n".data(using: .utf8)!)
            body.append(prompt.data(using: .utf8)!)
        }
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return try await httpClient.dynamicRequest(body: body, req: request, responseType: GenerateCharacterResponse.self)
    }
}
