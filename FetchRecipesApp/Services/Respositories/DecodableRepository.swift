//
//  DecodableRepository.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation

final class DecodableRepository<T: Decodable>: Repository {
    private let networkService: any NetworkServicing
    private let decoder: JSONDecoder
    
    init(networkService: any NetworkServicing = NetworkService(), decoder: JSONDecoder = JSONDecoder()) {
        self.networkService = networkService
        self.decoder = decoder
    }

    func fetch(for request: URLRequest?) async throws -> T {
        let data = try await networkService.fetchData(for: request)
        return try decoder.decode(T.self, from: data)
    }
}
