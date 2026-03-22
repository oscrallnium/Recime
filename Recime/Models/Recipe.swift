//
//  Recipe 2.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

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
}
