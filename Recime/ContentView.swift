//
//  ContentView.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/22/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                Text("HomeView")
            }
            Tab("Favorites", systemImage: "heart.fill") {
                Text("Favorites")
            }
            Tab("Settings", systemImage: "gearshape.fill") {
               Text("Settings")
            }
        }
        
        .tint(Color.accent)
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
