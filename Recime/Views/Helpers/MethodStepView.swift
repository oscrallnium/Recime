//
//  MethodStepView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/24/26.
//

import SwiftUI

struct MethodStepView: View {
    let instruction: Instruction
    var onTimerTap: ((Int) -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
          
            VStack {
                Text(instruction.formattedStep)
                    .font(.custom("Manrope-Bold", size: 36))
                    .foregroundStyle(Color.stepCounter)
                    .frame(width: 50, alignment: .leading)
                Spacer()
            }

            // Step content
            VStack(alignment: .leading, spacing: 10) {
                Text(instruction.title)
                    .font(.custom("Manrope-Bold", size: 17))
                    .foregroundStyle(Color.primaryText)
                Text(instruction.description)
                    .font(.bodyText(14))
                    .foregroundStyle(Color.secondaryText)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)

                if let minutes = instruction.timerMinutes {
                    TimerButton(minutes: minutes) {
                        onTimerTap?(minutes)
                    }
                    .padding(.top, 4)
                }
            }
        }
    }
}

/// Outlined timer button: "SET A 15 MIN TIMER"
struct TimerButton: View {
    let minutes: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "timer")
                    .font(.system(size: 13, weight: .medium))
                Text("SET A \(minutes) MIN TIMER")
                    .font(.uppercaseLabel(11))
                    .tracking(1)
            }
            .foregroundStyle(Color.accent)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.accent, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

struct MethodSection: View {
    let instructions: [Instruction]
    var onTimerTap: ((Int) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            // Section header
            Text("The Method")
                .font(.sectionHeader())
                .foregroundStyle(Color.accent)

            // Steps
            ForEach(instructions) { instruction in
                MethodStepView(
                    instruction: instruction,
                    onTimerTap: onTimerTap
                )
            }
        }
    }
}

#Preview {
    ScrollView {
        MethodSection(
            instructions: Recipe.previewFeatured.instructions,
            onTimerTap: { mins in print("Timer: \(mins) min") }
        )
        .padding()
    }
}
