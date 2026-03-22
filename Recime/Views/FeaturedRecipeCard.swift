//
//  FeaturedRecipeCard.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct FeaturedRecipeCard: View {
    let recipe: Recipe

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Hero image
            RecipeImage(name: recipe.image)
                .frame(height: 380)
                .clipped()

            // Gradient overlay
            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.15),
                    .black.opacity(0.55)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Content overlay
            VStack(alignment: .leading, spacing: 12) {
                // Dietary tag
                if recipe.isVegetarian {
                    DietaryTagView(text: "vegetarian")
                }

                // Title
                Text(recipe.title)
                    .font(.editorialTitle(30))
                    .foregroundStyle(.white)
                    .lineLimit(3)

                // Metadata row
                HStack(spacing: 16) {
                    Label(recipe.formattedPrepTime, systemImage: "clock")
                    Label(recipe.formattedCalories, systemImage: "flame")
                }
                .font(.metadata())
                .foregroundStyle(.white.opacity(0.9))
            }
            .padding(20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2), radius: 12, y: 4)
    }
}

#Preview {
    FeaturedRecipeCard(recipe: .previewFeatured)
        .padding()
}
