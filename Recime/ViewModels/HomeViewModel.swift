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
 
    // MARK: State
 
    var featuredRecipe: Recipe?
    var recipes: [Recipe] = []
    var moods: [Mood] = []
 
    var searchText: String = ""
    var selectedMood: Mood?
    var isVegetarianOnly: Bool = false
    var servingsFilter: ServingsFilter = .all
 
    var isLoading: Bool = false
    var error: RecipeServiceError?
 
    // MARK: Dependencies
 
    private let service: RecipeService
 
    init(service: RecipeService = MockRecipeService()) {
        self.service = service
    }
 
    // MARK: Filtered Results
 
    /// Applies all active filters: text search, mood, vegetarian, servings.
    /// Text search covers title, description, ingredient names, and instruction text.
    var filteredRecipes: [Recipe] {
        var results = recipes
 
        // Full-text search
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            results = results.filter { recipe in
                recipe.title.lowercased().contains(query)
                || recipe.description.lowercased().contains(query)
                || recipe.ingredients.contains { $0.name.lowercased().contains(query) }
                || recipe.instructions.contains {
                    $0.title.lowercased().contains(query)
                    || $0.description.lowercased().contains(query)
                }
            }
        }
 
        // Mood category
        if let mood = selectedMood {
            results = results.filter { $0.mood.contains(mood.id) }
        }
 
        // Dietary
        if isVegetarianOnly {
            results = results.filter { $0.isVegetarian }
        }
 
        // Servings
        if servingsFilter != .all {
            results = results.filter { servingsFilter.matches($0.servings) }
        }
 
        return results
    }
 
    /// Whether any filter is currently active (for showing a clear button)
    var hasActiveFilters: Bool {
        selectedMood != nil || isVegetarianOnly || servingsFilter != .all
    }
 
    // MARK: Actions
 
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
            self.error = .decodingFailed(error)
        }
 
        isLoading = false
    }
 
    func selectMood(_ mood: Mood) {
        selectedMood = (selectedMood == mood) ? nil : mood
    }
 
    func clearFilters() {
        selectedMood = nil
        isVegetarianOnly = false
        servingsFilter = .all
        searchText = ""
    }
}
