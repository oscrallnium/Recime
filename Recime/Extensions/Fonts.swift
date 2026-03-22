//
//  Fonts.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

extension Font {
    static func editorialTitle(_ size: CGFloat) -> Font {
        .system(size: size, design: .serif).weight(.bold)
    }

    static func sectionHeader(_ size: CGFloat) -> Font {
        .system(size: size, design: .serif).weight(.semibold)
    }

    static func label(_ size: CGFloat) -> Font {
        .system(size: size, design: .default).weight(.semibold)
    }
}
