//
//  RecipeDetailView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/24/26.
//

import SwiftUI
import Combine

struct RecipeDetailView: View {
    @State private var viewModel: RecipeDetailViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Timer State
    @State private var timeRemaining: Int = 0
    @State private var initialTime: Int = 0
    @State private var isTimerRunning: Bool = false
    @State private var showTimer: Bool = false

    init(recipe: Recipe) {
        _viewModel = State(initialValue: RecipeDetailViewModel(recipe: recipe))
    }

    private var recipe: Recipe { viewModel.recipe }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: - Hero Image (stretch on overscroll)
                    heroImage

                    // MARK: - Content
                    VStack(alignment: .leading, spacing: 24) {
                        // Tag pills (wrapping flow layout)
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
                            onTimerTap: { minutes in handleTimer(minutes) }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100) // Extra clearance for the floating timer
                }
            }
            .coordinateSpace(name: "detailScroll")
            .ignoresSafeArea(edges: .top)
            .background(Color.background)

            // MARK: - Floating Timer Overlay
            if showTimer {
                FloatingTimerView(
                    timeRemaining: $timeRemaining,
                    initialTime: $initialTime,
                    isTimerRunning: $isTimerRunning,
                    showTimer: $showTimer
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showTimer)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { backButton }
            ToolbarItem(placement: .topBarTrailing) { bookmarkButton }
        }
    }

    // MARK: - Hero Image

    private var heroImage: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("detailScroll")).minY
            // When offset > 0 the user is pulling down (overscroll) — stretch the image.
            let stretchOffset = max(0, offset)

            RecipeImage(name: recipe.image)
                .frame(width: proxy.size.width, height: 320 + stretchOffset, alignment: .top)
                .clipped()
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [.clear, Color.background.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 60)
                }
                .offset(y: -stretchOffset)
        }
        .frame(height: 320)
    }

    // MARK: - Tag Pills (wrapping)

    private var tagRow: some View {
        FlowLayout(spacing: 8) {
            ForEach(recipe.dietaryAttributes, id: \.self) { attribute in
                DietaryTagView(text: attribute)
            }

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
        Button { dismiss() } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.primaryText)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }

    private var bookmarkButton: some View {
        Button { viewModel.toggleFavorite() } label: {
            Image(systemName: viewModel.isFavorite ? "bookmark.fill" : "bookmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(viewModel.isFavorite ? Color.accent : Color.primaryText)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isFavorite)
    }

    // MARK: - Timer Handler

    private func handleTimer(_ minutes: Int) {
        let seconds = minutes * 60
        initialTime = seconds
        timeRemaining = seconds
        isTimerRunning = true
        showTimer = true
    }
}

// MARK: - Floating Timer View

struct FloatingTimerView: View {
    @Binding var timeRemaining: Int
    @Binding var initialTime: Int
    @Binding var isTimerRunning: Bool
    @Binding var showTimer: Bool

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private var isFinished: Bool { timeRemaining == 0 }

    var body: some View {
        HStack(spacing: 16) {
            // Time display
            Text(formattedTime)
                .font(.system(size: 22, weight: .semibold, design: .monospaced))
                .foregroundStyle(isFinished ? Color.accent : Color.primaryText)
                .animation(.easeInOut(duration: 0.2), value: isFinished)

            Spacer()

            // Play / Pause
            Button {
                guard !isFinished else { return }
                isTimerRunning.toggle()
            } label: {
                Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.accent)
                    .frame(width: 36, height: 36)
                    .background(Color.accent.opacity(0.12))
                    .clipShape(Circle())
            }
            .disabled(isFinished)

            // Reset
            Button {
                timeRemaining = initialTime
                isTimerRunning = false
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.secondaryText)
                    .frame(width: 36, height: 36)
                    .background(Color.cardBackground)
                    .clipShape(Circle())
            }

            // Dismiss
            Button {
                isTimerRunning = false
                showTimer = false
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color.secondaryText)
                    .frame(width: 36, height: 36)
                    .background(Color.cardBackground)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.12), radius: 16, y: 4)
        .onReceive(ticker) { _ in
            guard isTimerRunning else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Time's up — pause automatically
                isTimerRunning = false
            }
        }
    }
}

// MARK: - Flow Layout

/// A layout that arranges children left-to-right, wrapping to a new row
/// whenever the next item would exceed the available width.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var y: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0
        var firstInRow = true

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if !firstInRow && x + spacing + size.width > maxWidth {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
                firstInRow = true
            }

            if !firstInRow { x += spacing }
            x += size.width
            rowHeight = max(rowHeight, size.height)
            firstInRow = false
        }

        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        var firstInRow = true

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if !firstInRow && x + spacing + size.width > bounds.maxX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
                firstInRow = true
            }

            if !firstInRow { x += spacing }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width
            rowHeight = max(rowHeight, size.height)
            firstInRow = false
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: .previewFeatured)
    }
}
