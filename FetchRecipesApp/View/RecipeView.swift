//
//  RecipeView.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import SwiftUI

struct RecipeView: View {
    private enum Constants {
        static let padding: CGFloat = 8
        static let size: CGFloat = 100
        static let cornerRadius: CGFloat = 5
        static let titleFontSize: CGFloat = 18
    }
    @ObservedObject private var viewModel: RecipeImageViewModel
    
    var body: some View {
        HStack(spacing: Constants.padding) {
            RecipeImageView(viewModel: viewModel)
                .cornerRadius(Constants.cornerRadius)
                .frame(width: Constants.size, height: Constants.size)
            VStack(alignment: .leading, spacing: Constants.padding) {
                Text(viewModel.name)
                    .font(Font.system(size: Constants.titleFontSize))
                    .bold()
                Text(viewModel.cuisine)
            }
        }
        .padding([.leading, .trailing], Constants.padding)
    }
    
    init(viewModel: RecipeImageViewModel) {
        self.viewModel = viewModel
    }
}
