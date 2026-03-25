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
        Color.clear
            .frame(height: 340)
            
            .overlay {
                RecipeImage(name: recipe.image)
                    .scaledToFill()
            }
            
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("VEGETARIAN")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Capsule())
                        .foregroundStyle(Color(red: 0.3, green: 0.5, blue: 0.3))
                    
                    Text(recipe.title)
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text("\(recipe.prepTimeMinutes) MINS")
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "flame")
                            Text("420 KCAL")
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                }
                .padding(24)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .clipped()
    }
}

#Preview {
    FeaturedRecipeCard(recipe: .previewFeatured)
        .padding()
}
