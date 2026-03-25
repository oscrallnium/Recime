//
//  HomeViewModel.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

enum SortOption: String, CaseIterable, Identifiable {
    case relevance = "Relevance"
    case rating    = "Rating"
    case newest    = "Newest"

    var id: String { rawValue }
}

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
    var sortOption: SortOption = .relevance

    // Advanced filters
    var servingsAmount: Double = 1.0
    var includedIngredients: [String] = []
    var excludedIngredients: [String] = []

    var isLoading: Bool = false
    var error: RecipeServiceError?

    // MARK: Dependencies

    private let service: RecipeService

    init(service: RecipeService = MockRecipeService()) {
        self.service = service
    }

    // MARK: Filtered + Sorted Results

    /// Applies all active filters then sorts by the selected sort option.
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

        // Advanced: servings slider (active only when moved above minimum of 1)
        if servingsAmount > 1 {
            results = results.filter { $0.servings >= Int(servingsAmount) }
        }

        // Advanced: include ingredients — all tags must match at least one ingredient
        if !includedIngredients.isEmpty {
            results = results.filter { recipe in
                includedIngredients.allSatisfy { term in
                    recipe.ingredients.contains { $0.name.lowercased().contains(term) }
                }
            }
        }

        // Advanced: exclude ingredients — any tag match hides the recipe
        if !excludedIngredients.isEmpty {
            results = results.filter { recipe in
                excludedIngredients.allSatisfy { term in
                    !recipe.ingredients.contains { $0.name.lowercased().contains(term) }
                }
            }
        }

        // Sort
        switch sortOption {
        case .relevance:
            if !searchText.isEmpty {
                let query = searchText.lowercased()
                results = results.sorted {
                    relevanceScore($0, query: query) > relevanceScore($1, query: query)
                }
            }
        case .rating:
            results = results.sorted { $0.rating > $1.rating }
        case .newest:
            break // preserve original JSON order
        }

        return results
    }

    /// Scores a recipe based on where the query matches — title ranks highest.
    private func relevanceScore(_ recipe: Recipe, query: String) -> Int {
        var score = 0
        if recipe.title.lowercased().contains(query)       { score += 3 }
        if recipe.description.lowercased().contains(query) { score += 2 }
        if recipe.ingredients.contains(where: { $0.name.lowercased().contains(query) }) { score += 1 }
        return score
    }

    /// Whether any search-level filter is active (used to show/hide filter bar).
    var hasSearchFilters: Bool {
        isVegetarianOnly
            || servingsAmount > 1
            || !includedIngredients.isEmpty
            || !excludedIngredients.isEmpty
    }

    /// Whether any filter at all is active, including mood (used for the clear button).
    var hasActiveFilters: Bool {
        selectedMood != nil
            || isVegetarianOnly
            || servingsAmount > 1
            || !includedIngredients.isEmpty
            || !excludedIngredients.isEmpty
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

    /// Resets only the advanced filter panel values (servings, include, exclude).
    func clearAdvancedFilters() {
        servingsAmount = 1.0
        includedIngredients = []
        excludedIngredients = []
    }

    /// Resets all filters and search state.
    func clearFilters() {
        selectedMood = nil
        isVegetarianOnly = false
        sortOption = .relevance
        clearAdvancedFilters()
        searchText = ""
    }
}
