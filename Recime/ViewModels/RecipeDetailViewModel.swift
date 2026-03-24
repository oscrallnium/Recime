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
    var isCookingMode: Bool = false

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    // MARK: - Ingredient Checking

    func toggleIngredient(_ ingredient: Ingredient) {
        if checkedIngredients.contains(ingredient.id) {
            checkedIngredients.remove(ingredient.id)
        } else {
            checkedIngredients.insert(ingredient.id)
        }
    }

    func isChecked(_ ingredient: Ingredient) -> Bool {
        checkedIngredients.contains(ingredient.id)
    }

    var checkedCount: Int {
        checkedIngredients.count
    }

    var allIngredientsChecked: Bool {
        checkedIngredients.count == recipe.ingredients.count
    }

    // MARK: - Favorites

    func toggleFavorite() {
        isFavorite.toggle()
    }
}
