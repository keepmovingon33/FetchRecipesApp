//
//  Recipe.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation

struct RecipeList: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable, Identifiable, Equatable {
    let id: String
    let cuisine: String
    let name: String
    let largePhotoURL: URL?
    let smallPhotoURL: URL?
    let sourceURL: URL?
    let youtubeURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case largePhotoURL = "photo_url_large"
        case smallPhotoURL = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
        case cuisine, name
    }
}
