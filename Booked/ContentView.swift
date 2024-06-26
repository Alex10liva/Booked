//
//  ContentView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var tabSelection = 1
    @State var selectedTabInLibrary: Tab? = .readingList
    
    var body: some View {
        TabView(selection: $tabSelection){
            DiscoverView(tabSelection: $tabSelection, selectedTabInLibrary: $selectedTabInLibrary)
                .tabItem {
                    Label("Discover", systemImage: "sparkles")
                }
                .tag(1)
            
            LibraryView(selectedTabInLibrary: $selectedTabInLibrary, tabSelection: $tabSelection)
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
}
