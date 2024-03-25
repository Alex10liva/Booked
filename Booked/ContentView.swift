//
//  ContentView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Book]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { book in
                    VStack{
                        if let title = book.title{
                            Text(title)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
    }

    private func addItem(with book: Book) {
        withAnimation {
            let newItem = book
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
}
