//
//  Ingredient.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//
//
//import Foundation

struct Ingredient: Codable, Identifiable, Hashable {
    var id: String { name }
    let name: String
    let amount: String
    let unit: String

    /// Formatted display string: "3 tbsp white miso paste"
    var displayText: String {
        [amount, unit, name]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
