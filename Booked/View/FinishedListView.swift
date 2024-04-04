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
    @State private var isConfirming = false
    @State private var dialogDetail: BookDetails?
    @Binding var tabSelection: Int
    let defaults = UserDefaults.standard
    @State var deletedBooksIDs: [String] = []
    @Binding var selectedListOrder: ListOrder
    
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
                                    if let id = book.id, let title = book.title {
                                        dialogDetail = BookDetails(id: id, title: title)
                                    }
                                    isConfirming = true
                                } label: {
                                    Label("Remove book", systemImage: "trash")
                                }
                            }
                            .confirmationDialog(
                                "Are you sure you want to delete this book?",
                                isPresented: $isConfirming, titleVisibility: .visible, presenting: dialogDetail
                            ) { detail in
                                Button(role: .destructive) {
                                    
                                    deletedBooksIDs.append(detail.id)
                                    defaults.set(deletedBooksIDs, forKey: "deletedIDs")
                                    
                                    if let bookIndex = items.firstIndex(where: {$0.id == detail.id}){
                                        withAnimation{
                                            modelContext.delete(items[bookIndex])
                                        }
                                    }
                                } label: {
                                    Text("Delete \(detail.title)")
                                }
                                
                                Button("Cancel", role: .cancel) {
                                    dialogDetail = nil
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
                BookDescriptionView(book: fullScreenBook, selectedTab: $selectedTab, tabSelection: $tabSelection, showOptions: true, showActionButton: false)
            }
        }
        .onAppear{
            deletedBooksIDs = (defaults.array(forKey: "deletedIDs") ?? []) as? [String] ?? [""]
        }
    }
}

#Preview {
    FinishedListView(selectedTab: .constant(.finishedBooks), tabSelection: .constant(2), selectedListOrder: .constant(.dateAscending))
}
