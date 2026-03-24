//
//  RecipeDetailView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/24/26.
//

import SwiftUI

struct RecipeDetailView: View {
    @State private var viewModel: RecipeDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(recipe: Recipe) {
        _viewModel = State(initialValue: RecipeDetailViewModel(recipe: recipe))
    }

    private var recipe: Recipe { viewModel.recipe }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // MARK: - Hero Image
                heroImage

                // MARK: - Content
                VStack(alignment: .leading, spacing: 24) {
                    // Tag pills
                    tagRow

                    // Prep time
                    prepTimeBadge

                    // Title
                    Text(recipe.title)
                        .font(.editorialTitle(28))
                        .foregroundStyle(Color.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    // Description
                    Text(recipe.description)
                        .font(.bodyText(15))
                        .foregroundStyle(Color.secondaryText)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)

                    // Start Cooking Mode button
                    cookingModeButton

                    Divider()
                        .foregroundStyle(Color.divider)
                        .padding(.vertical, 8)

                    // MARK: - Ingredients
                    IngredientsSection(
                        ingredients: recipe.ingredients,
                        checkedIngredients: viewModel.checkedIngredients,
                        onToggle: { viewModel.toggleIngredient($0) }
                    )

                    Divider()
                        .foregroundStyle(Color.divider)
                        .padding(.vertical, 8)

                    // MARK: - Method
                    MethodSection(
                        instructions: recipe.instructions,
                        onTimerTap: { minutes in
                            handleTimer(minutes)
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.background)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .topBarTrailing) {
                bookmarkButton
            }
        }
    }

    // MARK: - Hero Image

    private var heroImage: some View {
        RecipeImage(name: recipe.image)
            .frame(height: 320)
            .clipped()
            .overlay(alignment: .bottom) {
                // Subtle gradient fade into content area
                LinearGradient(
                    colors: [.clear, Color.background.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 60)
            }
    }

    // MARK: - Tag Pills

    private var tagRow: some View {
        HStack(spacing: 8) {
            // Dietary tags
            ForEach(recipe.dietaryAttributes, id: \.self) { attribute in
                DietaryTagView(text: attribute)
            }

            // Servings tag
            Text("\(recipe.servings) \(recipe.servings == 1 ? "SERVING" : "SERVINGS")")
                .font(.uppercaseLabel(10))
                .tracking(1.5)
                .foregroundStyle(Color.secondaryText)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.moodBackground)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }

    // MARK: - Prep Time

    private var prepTimeBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock")
                .font(.system(size: 12))
            Text("\(recipe.prepTimeMinutes) MIN")
                .font(.metadata())
                .tracking(0.5)
        }
        .foregroundStyle(Color.secondaryText)
    }

    // MARK: - Cooking Mode Button

    private var cookingModeButton: some View {
        Button {
            viewModel.isCookingMode = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "fork.knife")
                    .font(.system(size: 14, weight: .semibold))

                Text("Start Cooking Mode")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.accent)
            .clipShape(RoundedRectangle(cornerRadius: 28))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Navigation Buttons

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.primaryText)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }

    private var bookmarkButton: some View {
        Button {
            viewModel.toggleFavorite()
        } label: {
            Image(systemName: viewModel.isFavorite ? "bookmark.fill" : "bookmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(
                    viewModel.isFavorite ? Color.accent : Color.primaryText
                )
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isFavorite)
    }

    // MARK: - Timer Handler

    private func handleTimer(_ minutes: Int) {
        // In a full implementation, this would trigger a Live Activity
        // or a local notification timer. For now, a simple alert or
        // haptic feedback could go here.
        print("Timer started: \(minutes) minutes")
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: .previewFeatured)
    }
}
