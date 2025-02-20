//
//  Repository.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation

protocol Repository {
    associatedtype T
    func fetch(for request: URLRequest?) async throws -> T
}
