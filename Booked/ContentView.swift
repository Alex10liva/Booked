//
//  ContentView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView{
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "sparkles")
                }
            
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
}
