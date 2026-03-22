//
//  RecipeResponse.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

struct RecipeResponse: Codable {
    let featured: Recipe
    let recipes: [Recipe]
    let moods: [Mood]

    /// All recipes including featured
    var allRecipes: [Recipe] {
        [featured] + recipes
    }
}
