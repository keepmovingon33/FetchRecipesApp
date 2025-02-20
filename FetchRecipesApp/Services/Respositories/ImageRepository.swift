//
//  ImageRepository.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation
import UIKit

enum ImageRepositoryError: Error {
    case invalidImage
}

class ImageRepository: Repository {
    private let networkService: any NetworkServicing
    private let cache: DataCache
    
    init(networkService: any NetworkServicing = NetworkService(), cache: DataCache = DataCache()) {
        self.networkService = networkService
        self.cache = cache
    }

    func fetch(for request: URLRequest?) async throws -> UIImage {
        let cacheKey = request?.url?.absoluteString ?? ""
        if let cachedData = cache.getData(for: cacheKey),
           let cachedImage = UIImage(data: cachedData) {
            return cachedImage
        }
        let data = try await networkService.fetchData(for: request)
        cache.setData(data, for: cacheKey)
        guard let image = UIImage(data: data) else {
            throw ImageRepositoryError.invalidImage
        }
        return image
    }
}
