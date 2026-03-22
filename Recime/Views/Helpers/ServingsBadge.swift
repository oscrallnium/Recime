//
//  ServingsBadge.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct ServingsBadge: View {
    let count: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 10))

            Text("\(count) \(count == 1 ? "SERVING" : "SERVINGS")")
                .font(.uppercaseLabel())
                .tracking(0.8)
        }
        .foregroundStyle(Color.secondaryText)
    }
}

#Preview {
    VStack {
        ServingsBadge(count: 1)
        ServingsBadge(count: 4)
    }
    .padding()
}
