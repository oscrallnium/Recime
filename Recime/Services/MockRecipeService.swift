//
//  MockRecipeService.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import Foundation

final class MockRecipeService: RecipeService {
    private let bundle: Bundle
    private let fileName: String
    private let simulatedDelay: Duration

    init(
        bundle: Bundle = .main,
        fileName: String = "recipes",
        simulatedDelay: Duration = .milliseconds(800)
    ) {
        self.bundle = bundle
        self.fileName = fileName
        self.simulatedDelay = simulatedDelay
    }

    func fetchRecipes() async throws -> RecipeResponse {
        // Simulate network latency
        try await Task.sleep(for: simulatedDelay)

        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw RecipeServiceError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(RecipeResponse.self, from: data)
        } catch let error as DecodingError {
            throw RecipeServiceError.decodingFailed(error)
        }
    }
}
