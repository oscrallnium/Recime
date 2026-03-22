//
//  Recipe.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import Foundation

struct Recipe: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let image: String
    let servings: Int
    let prepTimeMinutes: Int
    let calories: Int
    let rating: Double
    let isFeatured: Bool
    let dietaryAttributes: [String]
    let mood: [String]
    let ingredients: [Ingredient]
    let instructions: [Instruction]
 
    var isVegetarian: Bool {
        dietaryAttributes.contains("vegetarian")
    }
 
    /// Formatted prep time: "25 MINS"
    var formattedPrepTime: String {
        "\(prepTimeMinutes) MINS"
    }
 
    /// Formatted calories: "420 KCAL"
    var formattedCalories: String {
        "\(calories) KCAL"
    }
 
    /// Formatted rating: "4.9"
    var formattedRating: String {
        String(format: rating == 5.0 ? "%.1f" : "%.1f", rating)
    }
}
