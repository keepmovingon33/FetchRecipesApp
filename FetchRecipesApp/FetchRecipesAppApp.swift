//
//  FetchRecipesAppApp.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import SwiftUI

@main
struct FetchRecipesApp_App: App {
    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: RecipeListViewModel(recipeService: DecodableRepository<RecipeList>(), imageService: ImageRepository()))
        }
    }
}
