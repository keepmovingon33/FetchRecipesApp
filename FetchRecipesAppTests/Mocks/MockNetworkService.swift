//
//  MockNetworkService.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

@testable import FetchRecipesApp
import Foundation
import UIKit

final class MockNetworkService: NetworkServicing {
    private enum Constants {
        static let json = "json"
        static let photos = "photos"
    }
    
    private let imageData: Data?
    
    init(imageData: Data? = nil) {
        self.imageData = imageData
    }
    
    func fetchData(for request: URLRequest?) async throws -> Data {
        if let str = request?.url?.absoluteString, str.contains(Constants.photos) {
            return imageData ?? Data()
        }
        guard let url = Bundle(for: type(of: self)).url(forResource: request?.url?.absoluteString ?? "", withExtension: Constants.json) else {
            throw NSError(domain: "", code: 1)
        }
        return try Data(contentsOf: url)
    }
}
