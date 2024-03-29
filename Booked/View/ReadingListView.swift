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
    
    @StateObject private var selectedBookViewModel = SelectedBookVieModel()
    @Binding var selectedTab: Tab?
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                
                Spacer()
                    .frame(height: 50)
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 15){
                    
                    ForEach(items){ book in
                        BookItemInGrid(book: book)
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .onTapGesture {
                                selectedBookViewModel.selectedBook = book
                            }
                            .padding()
                            .contextMenu {
                                Button {
                                    withAnimation{
                                        selectedTab = .finishedBooks
                                        
                                        if let bookIndex = items.firstIndex(where: {$0.id == book.id}){
                                            items[bookIndex].addedDate = Date.now
                                            items[bookIndex].list = "finishedList"
                                        }
                                    }
                                } label: {
                                    Label("Move to finished books", systemImage: "arrow.right")
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
                    ContentUnavailableView("You don't have books in your reading list", systemImage: "sparkles", description: Text("Go to the discover page to get some books or tap the + to add books"))
                }
            }
            .fullScreenCover(item: $selectedBookViewModel.selectedBook){ fullScreenBook in
                BookDescriptionView(book: fullScreenBook)
            }
        }
        
    }
}

#Preview {
    ReadingListView(selectedTab: .constant(.readingList))
}
