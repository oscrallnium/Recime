//
//  EmptyStateView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

/// Friendly empty state shown when filters/search return no recipes.
struct EmptyStateView: View {
    let searchText: String
    let hasFilters: Bool
    var onClearFilters: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 48))
                .foregroundStyle(Color.secondaryText.opacity(0.5))

            Text(title)
                .font(.sectionTitle(18))
                .foregroundStyle(Color.primaryText)

            Text(subtitle)
                .font(.bodyText())
                .foregroundStyle(Color.secondaryText)
                .multilineTextAlignment(.center)

            if hasFilters, let onClear = onClearFilters {
                Button("Clear All Filters", action: onClear)
                    .font(.uppercaseLabel(12))
                    .tracking(0.5)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.accent)
                    .clipShape(Capsule())
                    .padding(.top, 4)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }

    private var title: String {
        if !searchText.isEmpty {
            return "No recipes found"
        } else if hasFilters {
            return "No matches"
        }
        return "Nothing here yet"
    }

    private var subtitle: String {
        if !searchText.isEmpty {
            return "We couldn't find any recipes matching \"\(searchText)\". Try a different search term."
        } else if hasFilters {
            return "No recipes match your current filters. Try adjusting them."
        }
        return "Check back soon for new recipes."
    }
}

#Preview {
    EmptyStateView(
        searchText: "dragon fruit",
        hasFilters: true,
        onClearFilters: {}
    )
}
