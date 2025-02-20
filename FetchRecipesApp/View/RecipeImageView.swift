//
//  RecipeImageView.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import SwiftUI

struct RecipeImageView: View {
    private enum Constants {
        static let size: CGFloat = 100
    }
    @ObservedObject private var viewModel: RecipeImageViewModel
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .task {
                    await viewModel.fetchImage()
                }
        case .loaded(let image):
            Image(uiImage: image)
                .resizable()
                .frame(width: Constants.size, height: Constants.size)
        case .error:
            errorImage
        }
    }
    
    var errorImage: some View {
        ZStack {
            Color(uiColor: .label)
            Image(systemName: "xmark")
                .resizable()
                .frame(width: Constants.size, height: Constants.size)
                .foregroundStyle(Color(uiColor: .systemBackground))
            
        }
    }
    
    init(viewModel: RecipeImageViewModel) {
        self.viewModel = viewModel
    }
}
