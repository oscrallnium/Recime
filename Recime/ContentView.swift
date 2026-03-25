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
        HomeView()
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
