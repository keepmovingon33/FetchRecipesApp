//
//  RecipeHighlightButtonViewModel.swift
//  FetchRecipesApp
//
//  Created by sky on 2/16/25.
//

import Foundation

final class RecipeHighlightButtonViewModel: ObservableObject, Identifiable {
    @Published var isSelected: Bool = false
    let label: String
    let index: Int
    let action: () async -> Void
    
    init(label: String, index: Int, action: @escaping () async -> Void) {
        self.label = label
        self.index = index
        self.action = action
    }
}
