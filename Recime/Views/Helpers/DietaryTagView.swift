//
//  DietaryTagView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct DietaryTagView: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.uppercaseLabel(10))
            .tracking(1.5)
            .foregroundStyle(Color.tagText)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.tagBackground)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    HStack {
        DietaryTagView(text: "vegetarian")
        DietaryTagView(text: "vegan")
        DietaryTagView(text: "gluten-free")
    }
    .padding()
}
