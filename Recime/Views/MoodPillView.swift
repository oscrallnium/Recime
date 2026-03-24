//
//  MoodPillView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct MoodPillView: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
 
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: mood.icon)
                    .font(.system(size: 24, weight: .medium))
 
                Text(mood.name.uppercased())
                    .font(.uppercaseLabel(10))
                    .tracking(1.2)
            }
            .foregroundStyle(isSelected ? .white : Color.moodIcon)
            .frame(width: 95, height: 95)
            .padding(.horizontal, 9)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.accent : Color.moodBackground)
                    .shadow(
                        color: .black.opacity(isSelected ? 0 : 0.04),
                        radius: 1, x: 0, y: 1
                    )
            )
            // Subtle inner shadow for the neumorphic feel
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        .white.opacity(isSelected ? 0.2 : 0.6),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

/// Horizontal scrollable row of mood categories.
/// Header: "Browse by Mood" with "VIEW ALL" link.
struct MoodCategorySection: View {
    let moods: [Mood]
    let selectedMood: Mood?
    let onSelect: (Mood) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text("Browse by Mood")
                    .font(.sectionTitle())
                    .foregroundStyle(Color.primaryText)

                Spacer()

                Button("VIEW ALL") {}
                    .font(.uppercaseLabel(11))
                    .tracking(1)
                    .foregroundStyle(Color.accent)
            }
            .padding(.horizontal, 24)

            // Horizontal scroll of pills with matching leading/trailing insets
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(moods) { mood in
                        MoodPillView(
                            mood: mood,
                            isSelected: selectedMood == mood,
                            action: { onSelect(mood) }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    MoodCategorySection(
        moods: Mood.previewMoods,
        selectedMood: nil,
        onSelect: { _ in }
    )
    .padding()
}
