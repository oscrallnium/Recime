//
//  RecipeImage.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import SwiftUI

struct RecipeImage: View {
    let name: String
 
    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
