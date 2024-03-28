//
//  FinishedListView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct FinishedListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Book> { book in
        book.list == "finishedList"
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
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .overlay{
                if items.isEmpty{
                    ContentUnavailableView("You don't have books listed as finished", systemImage: "checkmark", description: Text("Tap on the + to add some books and get more recommendations"))
                }
            }
        }
    }
}

#Preview {
    FinishedListView()
}
