//
//  NetworkService.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation

enum NetworkServiceError: Error {
    case badRequest
    case invalidServerResponse(_ statusCode: Int)
}

protocol NetworkServicing {
    func fetchData(for request: URLRequest?) async throws -> Data
}

final class NetworkService {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension NetworkService: NetworkServicing {
    func fetchData(for request: URLRequest?) async throws -> Data {
        guard let request else {
            throw NetworkServiceError.badRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200..<300).contains(httpResponse.statusCode) {
            throw NetworkServiceError.invalidServerResponse(httpResponse.statusCode)
        }
        
        return data
    }
}
