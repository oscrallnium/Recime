//
//  FilterBarView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct FilterBarView: View {
    @Binding var isVegetarianOnly: Bool
    @Binding var isAdvancedExpanded: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                FilterPill(
                    icon: "leaf.fill",
                    label: "Vegetarian",
                    isActive: isVegetarianOnly,
                    action: { isVegetarianOnly.toggle() }
                )

                FilterPill(
                    icon: isAdvancedExpanded ? "chevron.up" : "slider.horizontal.3",
                    label: "Filters",
                    isActive: isAdvancedExpanded,
                    action: { isAdvancedExpanded.toggle() }
                )
            }
        }
    }
}

struct FilterPill: View {
    let icon: String
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(label)
                    .font(.uppercaseLabel(11))
                    .tracking(0.5)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .foregroundStyle(isActive ? .white : Color.secondaryText)
            .background(isActive ? Color.accent : Color.cardBackground)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(
                        isActive ? Color.clear : Color.divider,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}
