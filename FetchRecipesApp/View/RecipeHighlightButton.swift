//
//  RecipeHighlightButton.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import SwiftUI

struct RecipeHighlightButton: View {
    private enum Constants {
        static let padding: CGFloat = 8
        static let opacity: Double = 0.2
        static let cornerRadius: CGFloat = 5
    }
    
    private static let backgroundColors = [
        Color(.systemRed),
        Color(.systemBlue),
        Color(.systemGreen),
        Color(.systemOrange),
        Color(.systemYellow),
        Color(.systemPink),
        Color(.systemPurple),
        Color(.systemBrown),
        Color(.systemTeal),
        Color(.systemGray),
        Color(.systemCyan),
        Color(.systemIndigo)
    ]
    @ObservedObject var viewModel: RecipeHighlightButtonViewModel
    
    var body: some View {
        Button(viewModel.label) {
            Task {
                viewModel.isSelected.toggle()
                await viewModel.action()
            }
        }
        .foregroundStyle(Color(.label))
        .padding(Constants.padding)
        .background {
            let backgroundColor = Self.backgroundColors[viewModel.index]
            viewModel.isSelected ? backgroundColor : backgroundColor.opacity(Constants.opacity)
        }
        .cornerRadius(Constants.cornerRadius)
    }
    
    init(viewModel: RecipeHighlightButtonViewModel) {
        self.viewModel = viewModel
    }
}
