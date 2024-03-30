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
    
    @StateObject private var selectedBookViewModel = SelectedBookVieModel()
    @Binding var selectedTab: Tab?
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                
                Spacer()
                    .frame(height: 60)
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 15){
                    
                    ForEach(items){ book in
                        BookItemInGrid(book: book)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .onTapGesture {
                                selectedBookViewModel.selectedBook = book
                            }
                            .padding(5)
                            .contextMenu {
                                Button {
                                    withAnimation{
                                        selectedTab = .readingList
                                        
                                        if let bookIndex = items.firstIndex(where: {$0.id == book.id}){
                                            items[bookIndex].addedDate = Date.now
                                            items[bookIndex].list = "readingList"
                                        }
                                    }
                                } label: {
                                    Label("Move to reading list", systemImage: "arrow.left")
                                }
                                
                                Button(role: .destructive) {
                                    withAnimation{
                                        if let bookIndex = items.firstIndex(where: {$0.id == book.id}){
                                            modelContext.delete(items[bookIndex])
                                        }
                                    }
                                } label: {
                                    Label("Remove book", systemImage: "trash")
                                }
                            }
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
            .fullScreenCover(item: $selectedBookViewModel.selectedBook){ fullScreenBook in
                BookDescriptionView(book: fullScreenBook, selectedTab: $selectedTab, showOptions: true)
            }
        }
        
    }
}

#Preview {
    FinishedListView(selectedTab: .constant(.finishedBooks))
}
