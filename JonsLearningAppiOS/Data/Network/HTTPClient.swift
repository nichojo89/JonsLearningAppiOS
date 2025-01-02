//
//  HTTPClient.swift
//  JonsLearningAppiOS
//
//  Created by Jon Nichols on 1/1/25.
//
import Foundation
import UIKit

class HTTPClient {
    let baseURL: URL = URL(string: "http://127.0.0.1:5167")!
    private let session: URLSession = .shared
    private var authenticator: FirebaseAuthenticator
    
    init(authenticator: FirebaseAuthenticator) {
        self.authenticator = authenticator
    }
    
    func post<T: Decodable, U: Encodable>(_ endpoint: String, body: U, responseType: T.Type) async throws -> T {
        try await request(endpoint, method: "POST", parameters: nil, body: body, responseType: responseType)
    }
    
    private func request<T: Decodable>(
        _ endpoint: String,
        method: String,
        parameters: [String: String]?,
        responseType: T.Type
    ) async throws -> T {
        return try await request(endpoint, method: method, parameters: parameters, body: Optional<String>.none, responseType: responseType)
    }
    
    private func request<T: Decodable, U: Encodable>(
        _ endpoint: String,
        method: String,
        parameters: [String: String]?,
        body: U?,
        responseType: T.Type
    ) async throws -> T {
        guard var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: true) else {
            throw HTTPError.invalidURL
        }
        
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw HTTPError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        try await authenticator.getToken{ token, success in
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw HTTPError.invalidBody
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw HTTPError.serverError(statusCode: httpResponse.statusCode, data: data)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw HTTPError.decodingError
        }
    }
}
extension HTTPClient {
    func dynamicRequest<T: Decodable>(body: Data, req: URLRequest, responseType: T.Type) async throws -> T {
        do {
            let group = DispatchGroup()
            var token: String?
            var tokenError: Error?

            group.enter()
            
            try await authenticator.getToken { receivedToken, success in
                if success {
                    token = receivedToken
                } else {
                    tokenError = HTTPError.decodingError
                }
                group.leave()
            }
            
            group.wait()
            
            if let error = tokenError {
                throw error
            }

            guard let finalToken = token else {
                throw HTTPError.invalidBody
            }
            
            var request = req
            request.setValue("Bearer \(finalToken)", forHTTPHeaderField: "Authorization")
            request.httpBody = body
            request.timeoutInterval = 120

            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw HTTPError.serverError(statusCode: httpResponse.statusCode, data: data)
            }

            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw HTTPError.decodingError
        }
    }
}

enum HTTPError: Error, CustomStringConvertible {
    case invalidImage
    case invalidURL
    case invalidBody
    case invalidResponse
    case serverError(statusCode: Int, data: Data)
    case decodingError
    
    var description: String {
        switch self {
        case .invalidImage:
            return "The image is invalid."
        case .invalidURL:
            return "The URL is invalid."
        case .invalidBody:
            return "The request body is invalid."
        case .invalidResponse:
            return "The response is invalid."
        case .serverError(let statusCode, let data):
            let message = String(data: data, encoding: .utf8) ?? "No error message"
            return "Server error with status code \(statusCode): \(message)"
        case .decodingError:
            return "Failed to decode the response."
        }
    }
}
