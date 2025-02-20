//
//  RecipeImageViewModel.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import UIKit

enum ImageState: Equatable {
    case loading
    case loaded(_ image: UIImage)
    case error(_ error: Error)
    
    static func == (lhs: ImageState, rhs: ImageState) -> Bool {
        lhs.description == rhs.description
    }
    
    var description: String {
        switch self {
        case .loading:
            "loading image"
        case .loaded:
            "loaded image"
        case .error:
            "error loading image"
        }
    }
}

final class RecipeImageViewModel: ObservableObject {
    private let imageService: ImageRepository
    private let recipe: Recipe
    @Published private(set) var state: ImageState = .loading
    
    var name: String {
        recipe.name
    }
    
    var cuisine: String {
        recipe.cuisine
    }
    
    init(imageService: ImageRepository, recipe: Recipe) {
        self.imageService = imageService
        self.recipe = recipe
    }
    
    func fetchImage() async {
        await updateState(.loading)
        do {
            let image = try await imageService.fetch(for: Environment.image(recipe.smallPhotoURL).request)
            await updateState(.loaded(image))
        } catch {
            await updateState(.error(error))
            // Perform logging
            print(error)
        }
    }
    
    @MainActor
    private func updateState(_ state: ImageState) {
        self.state = state
    }
}
