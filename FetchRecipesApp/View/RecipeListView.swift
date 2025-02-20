//
//  RecipeListView.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import SwiftUI

struct RecipeListView: View {
    private enum Constants {
        static let errorTitle = "Whoops, Something Went Wrong"
        static let errorButtonTitle = "Try Again"
        static let emptyTitle = "There are no recipes available"
        static let emptySubtitle = "Please check back at a later time"
        static let titleFontSize: CGFloat = 20
    }
    
    @ObservedObject private var viewModel: RecipeListViewModel
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .task {
                    await viewModel.fetchRecipes()
                }
        case .loaded(let recipes):
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.highlightButtonViewModels) { viewModel in
                            RecipeHighlightButton(viewModel: viewModel)
                        }
                    }
                    .padding()
                }
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(recipes) { recipe in
                            RecipeView(viewModel: viewModel.recipeImageViewModel(for: recipe))
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.fetchRecipes()
            }
        case .error:
            errorView
        case .empty:
            emptyView
        }
    }
    
    var errorView: some View {
        VStack {
            Text(Constants.errorTitle)
                .font(Font.system(size: Constants.titleFontSize))
                .bold()
            Button(Constants.errorButtonTitle) {
                Task {
                    await viewModel.retryFetchRecipes()
                }
            }
        }
    }
    
    var emptyView: some View {
        VStack {
            Text(Constants.emptyTitle)
                .font(Font.system(size: Constants.titleFontSize))
                .bold()
            Text(Constants.emptySubtitle)
        }
    }
    
    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
    }
}
