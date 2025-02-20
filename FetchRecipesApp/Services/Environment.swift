//
//  Environment.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation

enum Environment {
    private enum Path {
        static let recipePath = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        static let emptyPath = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        static let errorPath = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    }
    
    private enum Method {
        static let get = "GET"
    }
    
    // TODO: Remove empty and error paths
    case recipeList
    case emptyList
    case errorList
    case image(_ url: URL?)
    
    var request: URLRequest? {
        switch self {
        case .recipeList:
            guard let url = URL(string: Path.recipePath) else {
                return nil
            }
            return getRequest(for: url)
        case .image(let url):
            guard let url else {
                return nil
            }
            return getRequest(for: url)
        case .emptyList:
            guard let url = URL(string: Path.emptyPath) else {
                return nil
            }
            return getRequest(for: url)
        case .errorList:
            guard let url = URL(string: Path.errorPath) else {
                return nil
            }
            return getRequest(for: url)
        }
    }
    
    private func getRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = Method.get
        return request
    }
}
