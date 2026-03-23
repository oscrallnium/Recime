//
//  Fonts.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

extension Font {
 
    /// Hero title, recipe detail title — large serif bold
    static func editorialTitle(_ size: CGFloat = 32) -> Font {
        Font.custom("Manrope-Bold", size: size)
    }
 
    /// Section headers like "Trending Now", "Browse by Mood"
    static func sectionTitle(_ size: CGFloat = 22) -> Font {
        Font.custom("Manrope-SemiBold", size: size)
    }
 
    /// Serif section headers for detail screen ("The Ingredients", "The Method")
    static func sectionHeader(_ size: CGFloat = 24) -> Font {
        Font.custom("Manrope-SemiBold", size: size)
    }
 
    /// Recipe card titles
    static func cardTitle(_ size: CGFloat = 16) -> Font {
        Font.custom("Manrope-Bold", size: size)
    }
 
    /// Uppercase spaced labels: "VEGETARIAN", "4 SERVINGS", "4.9 RATING"
    static func uppercaseLabel(_ size: CGFloat = 11) -> Font {
        Font.custom("Manrope-SemiBold", size: size)
    }
 
    /// Body/description text
    static func bodyText(_ size: CGFloat = 14) -> Font {
        Font.custom("Manrope-Regular", size: size)
    }
 
    /// Small metadata (prep time, calories)
    static func metadata(_ size: CGFloat = 12) -> Font {
        Font.custom("Manrope-Medium", size: size)
    }
 
    /// Subtitle text like "Curated Daily"
    static func subtitle(_ size: CGFloat = 14) -> Font {
        Font.custom("Manrope-Light", size: size)
    }
}
