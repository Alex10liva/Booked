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
    }) private var items: [Book]
    
    @State private var isAddSheetDisplayed: Bool = false
    @State private var orderedBooks: [Book] = []
    
    var body: some View {
        ScrollView(.vertical){
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 15){
                
                ForEach(items){ book in
                    BookItemInGrid(book: book)
                        .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .padding()
            
            Spacer()
                .frame(height: 64)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    FinishedListView()
}
