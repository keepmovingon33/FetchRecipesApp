//
//  RecipeListViewModel.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation

enum RecipeListState: Equatable {
    case loading
    case loaded(_ filteredRecipes: [Recipe])
    case error(_ error: Error)
    case empty
    
    static func == (lhs: RecipeListState, rhs: RecipeListState) -> Bool {
        lhs.description == rhs.description
    }
    
    var description: String {
        switch self {
        case .loading:
            "loading recipe list"
        case .loaded:
            "loaded recipe list"
        case .empty:
            "loaded empty recipe list"
        case .error:
            "error loading recipe list"
        }
    }
}

final class RecipeListViewModel: ObservableObject {
    private let recipeService: DecodableRepository<RecipeList>
    private let imageService: ImageRepository
    private var recipes: [Recipe] = []
    private var filterQueries: [String] = []
    @Published private(set) var state: RecipeListState = .loading
    private(set) var highlightButtonViewModels: [RecipeHighlightButtonViewModel] = []
    
    init(recipeService: DecodableRepository<RecipeList>, imageService: ImageRepository) {
        self.recipeService = recipeService
        self.imageService = imageService
    }
    
    func fetchRecipes(for request: URLRequest? = Environment.recipeList.request) async {
        do {
            let recipeList = try await recipeService.fetch(for: request)
            recipes = recipeList.recipes
            await updateHighlightButtonViewModels()
            if recipes.isEmpty {
                await updateState(.empty)
                return
            }
            await updateState(.loaded(recipeList.recipes))
        } catch {
            await updateState(.error(error))
            // Perform logging
            print(error)
        }
    }
    
    func retryFetchRecipes(for request: URLRequest? = Environment.recipeList.request) async {
        await updateState(.loading)
        await fetchRecipes(for: request)
    }
    
    @MainActor
    private func updateHighlightButtonViewModels() async {
        let sortedCuisines = Set<String>(recipes.map{
            $0.cuisine
        }).sorted()
        
        highlightButtonViewModels = sortedCuisines.enumerated().map{ (index, cuisine) in
            RecipeHighlightButtonViewModel(label: cuisine, index: index) { [weak self] in
                await self?.updateFilter(with: cuisine)
            }
        }
        filterQueries = []
    }
    
    @MainActor
    private func updateState(_ state: RecipeListState) {
        self.state = state
    }
    
    func updateFilter(with query: String) async {
        if filterQueries.contains(query) {
            filterQueries.removeAll {
                $0 == query
            }
            await filterRecipes()
            return
        }
        filterQueries.append(query)
        await filterRecipes()
    }
    
    private func filterRecipes() async {
        let updatedRecipes = recipes.filter {
            filterQueries.contains($0.cuisine)
        }.sorted { lhs, rhs in
            lhs.cuisine == rhs.cuisine ? lhs.name < rhs.name : lhs.cuisine < rhs.cuisine
        }
        await updateState(.loaded(updatedRecipes.isEmpty ? recipes : updatedRecipes))
    }
    
    func recipeImageViewModel(for recipe: Recipe) -> RecipeImageViewModel {
        RecipeImageViewModel(imageService: imageService, recipe: recipe)
    }
}
