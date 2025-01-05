//
//  Txt2ImgUseCase.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/4/25.
//

import Foundation
import UIKit

protocol Txt2ImgUseCase {
    func getTxt2Img(prompt: String, negativePrompt: String) async throws -> GenerateCharacterResponse?
}
class Txt2ImgUseCaseImpl: Txt2ImgUseCase {
    private var httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getTxt2Img(prompt: String, negativePrompt: String) async throws -> GenerateCharacterResponse?  {
        let url = self.httpClient.baseURL.appendingPathComponent("TextToImage/GenerateCharacterTxt2Img")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"prompt\"\r\n".data(using: .utf8)!)
        if !prompt.isEmpty {
            body.append("\r\n".data(using: .utf8)!)
            body.append(prompt.data(using: .utf8)!)
        }
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"negative_prompt\"\r\n".data(using: .utf8)!)
        if !negativePrompt.isEmpty {
            body.append("\r\n".data(using: .utf8)!)
            body.append(negativePrompt.data(using: .utf8)!)
        }
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        do {
            return try await httpClient.dynamicRequest(body: body, req: request, responseType: GenerateCharacterResponse.self)
        } catch {
            return nil
        }
    }
}
