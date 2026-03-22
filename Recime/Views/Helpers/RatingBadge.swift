//
//  RatingBadge.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct RatingBadge: View {
    let rating: Double
 
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 10))
 
            Text("\(String(format: "%.1f", rating)) RATING")
                .font(.uppercaseLabel())
                .tracking(1)
        }
        .foregroundStyle(Color.accent)
    }
}
 
