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
            VStack(spacing: 8) {
                Image(systemName: mood.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? .white : Color.moodIcon)
                    .frame(width: 50, height: 50)
                    .background(
                        isSelected
                            ? Color.accent
                            : Color.moodBackground
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                Text(mood.name.uppercased())
                    .font(.uppercaseLabel(9))
                    .tracking(1)
                    .foregroundStyle(
                        isSelected
                            ? Color.accent
                            : Color.secondaryText
                    )
            }
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

            // Horizontal scroll of pills
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
