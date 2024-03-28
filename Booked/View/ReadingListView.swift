//
//  ReadingListView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct ReadingListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Book> { book in
        book.list == "readingList"
    }, sort: \Book.addedDate, order: .reverse) private var items: [Book]
    
    @State private var isAddSheetDisplayed: Bool = false
    @State private var orderedBooks: [Book] = []
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                
                Spacer()
                    .frame(height: 60)
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 15){
                    
                    ForEach(items){ book in
                        BookItemInGrid(book: book)
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                
                .padding()
            }
            .scrollIndicators(.hidden)
            .overlay{
                if items.isEmpty{
                    ContentUnavailableView("You don't have books in your reading list", systemImage: "sparkles", description: Text("Go to the discover page to get some books or tap the + to add books"))
                }
            }
        }
    }
}

#Preview {
    ReadingListView()
}
