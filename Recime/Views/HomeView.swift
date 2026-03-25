//
//  HomeView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var isAdvancedExpanded = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // MARK: - Featured Hero Card
                        if let featured = viewModel.featuredRecipe {
                            NavigationLink(value: featured) {
                                FeaturedRecipeCard(recipe: featured)
                            }
                            .buttonStyle(.plain)
                        }

                        // MARK: - Search Bar
                        SearchBarView(text: $viewModel.searchText)
                            .padding(.horizontal, 24)

                        // MARK: - Filter Bar
                        // Shown when searching, filters are active, or advanced panel is open
                        if !viewModel.searchText.isEmpty || viewModel.hasSearchFilters || isAdvancedExpanded {
                            FilterBarView(
                                isVegetarianOnly: $viewModel.isVegetarianOnly,
                                isAdvancedExpanded: $isAdvancedExpanded
                            )
                            .padding(.horizontal, 24)
                            .transition(.move(edge: .top).combined(with: .opacity))

                            // MARK: - Advanced Filters Panel
                            if isAdvancedExpanded {
                                AdvancedFiltersView(
                                    servings: $viewModel.servingsAmount,
                                    includedIngredients: $viewModel.includedIngredients,
                                    excludedIngredients: $viewModel.excludedIngredients,
                                    onClearAll: {
                                        viewModel.clearFilters()
                                        isAdvancedExpanded = false
                                    }
                                )
                                .padding(.horizontal, 24)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }

                        // MARK: - Browse by Mood
                        if viewModel.searchText.isEmpty && !viewModel.hasSearchFilters && !isAdvancedExpanded {
                            MoodCategorySection(
                                moods: viewModel.moods,
                                selectedMood: viewModel.selectedMood,
                                onSelect: { viewModel.selectMood($0) }
                            )
                        }

                        // MARK: - Trending Now / Results
                        trendingSection
                            .padding(.horizontal, 24)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 80)
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.searchText)
                .animation(.easeInOut(duration: 0.3), value: viewModel.hasSearchFilters)
                .animation(.easeInOut(duration: 0.3), value: isAdvancedExpanded)

                fabButton
            }
            .background(Color.background)
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Menu action
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.primaryText)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("Recime")
                        .font(.sectionTitle())
                        .tracking(1)
                        .foregroundStyle(Color.accent)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    profileAvatar
                }
            }
            // When the advanced panel is collapsed, clear its filters
            .onChange(of: isAdvancedExpanded) { _, expanded in
                if !expanded {
                    viewModel.clearAdvancedFilters()
                }
            }
        }
        .task {
            await viewModel.loadRecipes()
        }
    }

    // MARK: - Trending Section

    @ViewBuilder
    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            if viewModel.searchText.isEmpty && viewModel.selectedMood == nil && !viewModel.hasSearchFilters && !isAdvancedExpanded {
                HStack(alignment: .firstTextBaseline) {
                    Text("Trending Now")
                        .font(.sectionTitle())
                        .foregroundStyle(Color.primaryText)

                    Spacer()

                    Text("Curated Daily")
                        .font(.subtitle())
                        .foregroundStyle(Color.secondaryText)
                }
            } else {
                HStack(alignment: .center) {
                    Text("Found \(viewModel.filteredRecipes.count) Results")
                        .font(.sectionTitle())
                        .foregroundStyle(Color.primaryText)

                    Spacer()

                    Menu {
                        ForEach(SortOption.allCases) { option in
                            Button {
                                viewModel.sortOption = option
                            } label: {
                                HStack {
                                    Text(option.rawValue)
                                    if viewModel.sortOption == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text("SORT BY:")
                                .font(.caption)
                                .foregroundStyle(Color.secondaryText)
                                .fontWeight(.semibold)

                            Text(viewModel.sortOption.rawValue)
                                .font(.subheadline)
                                .foregroundStyle(Color.primaryText)

                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundStyle(Color.primaryText)
                        }
                    }
                }
                .padding(.vertical, 8)
            }

            // Recipe list or empty state
            if viewModel.isLoading {
                loadingPlaceholders
            } else if viewModel.filteredRecipes.isEmpty {
                EmptyStateView(
                    searchText: viewModel.searchText,
                    hasFilters: viewModel.hasSearchFilters,
                    onClearFilters: {
                        viewModel.clearFilters()
                        isAdvancedExpanded = false
                    }
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredRecipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeCardView(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    // MARK: - Loading Placeholders

    private var loadingPlaceholders: some View {
        VStack(spacing: 12) {
            ForEach(0..<3, id: \.self) { _ in
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.divider)
                        .frame(width: 100, height: 100)

                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.divider)
                            .frame(height: 12)
                            .frame(maxWidth: 80)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.divider)
                            .frame(height: 16)
                            .frame(maxWidth: 160)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.divider)
                            .frame(height: 12)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.divider)
                            .frame(height: 10)
                            .frame(maxWidth: 90)
                    }
                    Spacer()
                }
                .padding(14)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .redacted(reason: .placeholder)
            .shimmer()
        }
    }

    // MARK: - FAB

    private var fabButton: some View {
        Button {
            // Add recipe action
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.accent)
                .clipShape(Circle())
                .shadow(color: Color.accent.opacity(0.4), radius: 10, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }

    // MARK: - Profile Avatar

    private var profileAvatar: some View {
        Circle()
            .fill(Color.moodBackground)
            .frame(width: 34, height: 34)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.secondaryText)
            )
    }
}

// MARK: - Advanced Filters View

struct AdvancedFiltersView: View {
    @Binding var servings: Double
    @Binding var includedIngredients: [String]
    @Binding var excludedIngredients: [String]
    var onClearAll: () -> Void

    @State private var includeText = ""
    @State private var excludeText = ""

    let rustAccent = Color(red: 0.65, green: 0.22, blue: 0.11)
    let cardBeige  = Color(red: 0.97, green: 0.96, blue: 0.94)

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // Header
            HStack(alignment: .bottom) {
                Text("Advanced Filters")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primaryText)

                Spacer()

                Button(action: onClearAll) {
                    Text("CLEAR ALL")
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(1)
                        .foregroundStyle(rustAccent)
                }
            }

            // Servings Slider
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("NUMBER OF SERVINGS")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .tracking(1)
                        .foregroundStyle(Color.secondaryText)

                    Spacer()

                    Text("\(Int(servings)) People")
                        .font(.headline)
                        .foregroundStyle(rustAccent)
                }

                Slider(value: $servings, in: 1...12, step: 1)
                    .tint(rustAccent)

                HStack {
                    Text("1 SERVING")
                    Spacer()
                    Text("12 SERVINGS")
                }
                .font(.caption2)
                .foregroundStyle(Color.secondaryText)
            }

            // Include Ingredients
            ingredientSection(
                title: "INCLUDE INGREDIENTS",
                placeholder: "e.g. Garlic",
                icon: "plus.circle.fill",
                text: $includeText,
                tags: $includedIngredients,
                isExclude: false
            )

            // Exclude Ingredients
            ingredientSection(
                title: "EXCLUDE INGREDIENTS",
                placeholder: "e.g. Nuts",
                icon: "minus.circle.fill",
                text: $excludeText,
                tags: $excludedIngredients,
                isExclude: true
            )
        }
        .padding(24)
        .background(cardBeige)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    @ViewBuilder
    private func ingredientSection(
        title: String,
        placeholder: String,
        icon: String,
        text: Binding<String>,
        tags: Binding<[String]>,
        isExclude: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .tracking(1)
                .foregroundStyle(Color.secondaryText)

            // Input row
            HStack {
                TextField(placeholder, text: text)
                    .font(.subheadline)
                    .onSubmit { addTag(text: text, tags: tags, isExclude: isExclude) }

                Button {
                    addTag(text: text, tags: tags, isExclude: isExclude)
                } label: {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(
                            text.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty
                                ? Color.secondaryText.opacity(0.3)
                                : (isExclude ? Color.red.opacity(0.7) : Color.accent)
                        )
                }
                .disabled(text.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
            .background(Color.black.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Tag chips
            if !tags.wrappedValue.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(tags.wrappedValue, id: \.self) { tag in
                            IngredientTagChip(name: tag, isExclude: isExclude) {
                                tags.wrappedValue.removeAll { $0 == tag }
                            }
                        }
                    }
                }
            }
        }
    }

    private func addTag(text: Binding<String>, tags: Binding<[String]>, isExclude: Bool) {
        let trimmed = text.wrappedValue.trimmingCharacters(in: .whitespaces).lowercased()
        guard !trimmed.isEmpty, !tags.wrappedValue.contains(trimmed) else { return }
        tags.wrappedValue.append(trimmed)
        text.wrappedValue = ""
    }
}

// MARK: - Ingredient Tag Chip

struct IngredientTagChip: View {
    let name: String
    let isExclude: Bool
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(name)
                .font(.caption)
                .fontWeight(.medium)

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .foregroundStyle(isExclude ? Color.red : Color.accent)
        .background(isExclude ? Color.red.opacity(0.1) : Color.accent.opacity(0.12))
        .clipShape(Capsule())
    }
}

// MARK: - Shimmer Modifier

/// Adds a subtle shimmer animation to loading placeholders.
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [.clear, Color.white.opacity(0.4), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(20))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 350
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Preview

#Preview("Home - Loaded") {
    HomeView()
}
