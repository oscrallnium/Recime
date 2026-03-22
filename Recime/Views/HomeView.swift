//
//  HomeView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
 
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                // Main scrollable content
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
 
                        // MARK: - Filter Pills
                        // Shown when searching or filters are active
                        if !viewModel.searchText.isEmpty || viewModel.hasActiveFilters {
                            FilterBarView(
                                isVegetarianOnly: $viewModel.isVegetarianOnly,
                                servingsFilter: $viewModel.servingsFilter
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
 
                        // MARK: - Browse by Mood
                        if viewModel.searchText.isEmpty {
                            MoodCategorySection(
                                moods: viewModel.moods,
                                selectedMood: viewModel.selectedMood,
                                onSelect: { viewModel.selectMood($0) }
                            )
                        }
 
                        // MARK: - Trending Now
                        trendingSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 80) // Clear the FAB
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.searchText)
                .animation(.easeInOut(duration: 0.3), value: viewModel.hasActiveFilters)
 
                // MARK: - Floating Action Button
                fabButton
            }
            .background(Color.background)
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailPlaceholder(recipe: recipe)
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
                        .font(.uppercaseLabel(13))
                        .tracking(2)
                        .foregroundStyle(Color.accent)
                }
 
                ToolbarItem(placement: .topBarTrailing) {
                    profileAvatar
                }
            }
            .toolbarBackground(Color.background, for: .navigationBar)
        }
        .task {
            await viewModel.loadRecipes()
        }
    }
 
    // MARK: - Trending Section
 
    @ViewBuilder
    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Section header
            if viewModel.searchText.isEmpty && viewModel.selectedMood == nil {
                HStack(alignment: .firstTextBaseline) {
                    Text("Trending Now")
                        .font(.sectionTitle())
                        .foregroundStyle(Color.primaryText)
 
                    Spacer()
 
                    Text("Curated Daily")
                        .font(.subtitle())
                        .foregroundStyle(Color.secondaryText)
                }
            } else if !viewModel.searchText.isEmpty {
                Text("Search Results")
                    .font(.sectionTitle())
                    .foregroundStyle(Color.primaryText)
            }
 
            // Recipe list or empty state
            if viewModel.isLoading {
                loadingPlaceholders
            } else if viewModel.filteredRecipes.isEmpty {
                EmptyStateView(
                    searchText: viewModel.searchText,
                    hasFilters: viewModel.hasActiveFilters,
                    onClearFilters: { viewModel.clearFilters() }
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

// MARK: - Shimmer Modifier
 
/// Adds a subtle shimmer animation to loading placeholders.
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
 
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        Color.white.opacity(0.4),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(20))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
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
 
// MARK: - Placeholder for Detail (replace with your real detail view)
 
struct RecipeDetailPlaceholder: View {
    let recipe: Recipe
 
    var body: some View {
        ScrollView {
            Text(recipe.title)
                .font(.editorialTitle())
                .padding()
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
 
// MARK: - Preview
 
#Preview("Home - Loaded") {
    HomeView()
}
