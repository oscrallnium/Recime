//
//  IngredientRow.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/24/26.
//

import SwiftUI

struct IngredientRow: View {
    let ingredient: Ingredient
    let isChecked: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(
                            isChecked ? Color.accent : Color.divider,
                            lineWidth: 1.5
                        )
                        .frame(width: 22, height: 22)

                    if isChecked {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.accent.opacity(0.1))
                            .frame(width: 22, height: 22)

                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Color.accent)
                    }
                }

                // Ingredient text
                Text(ingredient.displayText)
                    .font(.bodyText(15))
                    .foregroundStyle(
                        isChecked
                            ? Color.secondaryText
                            : Color.primaryText
                    )
                    .strikethrough(isChecked, color: Color.secondaryText)

                Spacer()
            }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isChecked)
    }
}

/// The full ingredients section: serif header, subtitle, and checkbox list.
struct IngredientsSection: View {
    let ingredients: [Ingredient]
    let checkedIngredients: Set<String>
    let onToggle: (Ingredient) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            VStack(alignment: .leading, spacing: 4) {
                Text("The Ingredients")
                    .font(.sectionHeader())
                    .foregroundStyle(Color.accent)

                Text("Sourced from the market, prepared with intention.")
                    .font(.bodyText(13))
                    .foregroundStyle(Color.secondaryText)
                    .italic()
            }

            // Ingredient list
            VStack(spacing: 14) {
                ForEach(ingredients) { ingredient in
                    IngredientRow(
                        ingredient: ingredient,
                        isChecked: checkedIngredients.contains(ingredient.id),
                        onToggle: { onToggle(ingredient) }
                    )

                    if ingredient.id != ingredients.last?.id {
                        Divider()
                            .foregroundStyle(Color.divider.opacity(0.5))
                    }
                }
            }
        }
    }
}

#Preview {
    IngredientsSection(
        ingredients: Recipe.previewFeatured.ingredients,
        checkedIngredients: ["tahini"],
        onToggle: { _ in }
    )
    .padding()
}
