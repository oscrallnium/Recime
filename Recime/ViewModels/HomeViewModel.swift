//
//  HomeViewModel.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

@Observable
@MainActor
final class HomeViewModel {
    // MARK: - Published State
    var featuredRecipe: Recipe?
    var recipes: [Recipe] = []
    var moods: [Mood] = []
    var searchText: String = ""
    var selectedMood: Mood?
    var isVegetarianOnly: Bool = false
    var isLoading: Bool = false
    var error: RecipeServiceError?

    // MARK: - Dependencies
    private let service: RecipeService

    init(service: RecipeService = MockRecipeService()) {
        self.service = service
    }

    // MARK: - Computed: Filtered Recipes

    var filteredRecipes: [Recipe] {
        var results = recipes

        // Text search: title, description, ingredients, instructions
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            results = results.filter { recipe in
                recipe.title.lowercased().contains(query)
                || recipe.description.lowercased().contains(query)
                || recipe.ingredients.contains { $0.name.lowercased().contains(query) }
                || recipe.instructions.contains { $0.description.lowercased().contains(query) }
            }
        }

        // Mood filter
        if let mood = selectedMood {
            results = results.filter { $0.mood.contains(mood.id) }
        }

        // Vegetarian filter
        if isVegetarianOnly {
            results = results.filter { $0.dietaryAttributes.contains("vegetarian") }
        }

        return results
    }

    // MARK: - Actions
    func loadRecipes() async {
        isLoading = true
        error = nil

        do {
            let response = try await service.fetchRecipes()
            featuredRecipe = response.featured
            recipes = response.recipes
            moods = response.moods
        } catch let serviceError as RecipeServiceError {
            error = serviceError
        } catch {
            self.error = .networkError(error)
        }

        isLoading = false
    }

    func selectMood(_ mood: Mood) {
        // TODO: check if this can be one-liner
        if selectedMood == mood {
            selectedMood = nil  // Toggle off
        } else {
            selectedMood = mood
        }
    }
}
