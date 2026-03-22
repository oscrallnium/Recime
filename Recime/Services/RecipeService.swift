//
//  RecipeService.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import Foundation

protocol RecipeService: Sendable {
    func fetchRecipes() async throws -> RecipeResponse
}

// MARK: - RecipeServiceError.swift
enum RecipeServiceError: LocalizedError {
    case fileNotFound
    case decodingFailed(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Recipe data file could not be found."
        case .decodingFailed(let error):
            return "Failed to decode recipe data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
