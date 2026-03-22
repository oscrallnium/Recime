//
//  RecipeCardView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 16) {
            // Recipe image (rounded square)
            RecipeImage(name: recipe.image)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            // Text content
            VStack(alignment: .leading, spacing: 6) {
                RatingBadge(rating: recipe.rating)

                Text(recipe.title)
                    .font(.cardTitle())
                    .foregroundStyle(Color.primaryText)
                    .lineLimit(2)

                Text(recipe.description)
                    .font(.bodyText(13))
                    .foregroundStyle(Color.secondaryText)
                    .lineLimit(2)

                ServingsBadge(count: recipe.servings)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.black.opacity(0.2), radius: 6, y: 2)
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        VStack(spacing: 12) {
//            RecipeCardView(recipe: .previewRecipes[0])
        }
        .padding()
    }
}
