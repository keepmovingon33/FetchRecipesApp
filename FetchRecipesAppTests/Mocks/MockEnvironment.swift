//
//  MockEnvironment.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation

enum MockEnvironment {
    private enum Path {
        static let recipePath = "RecipesList"
        static let emptyPath = "EmptyRecipeList"
        static let errorPath = "MalformedRecipeList"
    }
    
    case recipeList
    case emptyList
    case errorList
    case image(_ imageURL: URL?)
    
    var request: URLRequest? {
        switch self {
        case .recipeList:
            return createRequest(with: Path.recipePath)
        case .emptyList:
            return createRequest(with: Path.emptyPath)
        case .errorList:
            return createRequest(with: Path.errorPath)
        case .image(let imageURL):
            guard let imageURL else {
                return nil
            }
            return URLRequest(url: imageURL)
        }
    }
    
    private func createRequest(with path: String) -> URLRequest? {
        guard let url = URL(string: path) else {
            return nil
        }
        return URLRequest(url: url)
    }
}
