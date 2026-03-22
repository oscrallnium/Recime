//
//  RecipeDetailViewModel.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

@Observable
@MainActor
final class RecipeDetailViewModel {
    let recipe: Recipe
    var checkedIngredients: Set<String> = []
    var isFavorite: Bool = false

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    func toggleIngredient(_ ingredient: Ingredient) {
        if checkedIngredients.contains(ingredient.name) {
            checkedIngredients.remove(ingredient.name)
        } else {
            checkedIngredients.insert(ingredient.name)
        }
    }

    func isChecked(_ ingredient: Ingredient) -> Bool {
        checkedIngredients.contains(ingredient.name)
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }
}
