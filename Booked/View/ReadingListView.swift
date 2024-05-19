//
//  ReadingListView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct BookDetails: Identifiable {
    var id: String
    let title: String
}

struct ReadingListView: View {
    
    // MARK: - Environment properties
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Swift data queries
    // Filter the books that are in the readingList
    @Query(filter: #Predicate<Book> { book in
        book.list == "readingList"
    }, sort: \Book.addedDate, order: .reverse) private var readingListBooks: [Book]
    
    // MARK: - State object
    @StateObject private var selectedBookViewModel = SelectedBookVieModel()
    
    // MARK: - Properties
    @State private var isConfirming = false
    @State private var dialogDetail: BookDetails?
    @State var deletedBooksIDs: [String] = []
    @Binding var selectedTabInLibrary: Tab?
    @Binding var tabSelection: Int
    let defaults = UserDefaults.standard
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                
                // Spacer because we are using a custom tab bar
                Spacer()
                    .frame(height: 60)
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 15){
                    // Display all the books that are in the reading list
                    ForEach(readingListBooks){ book in
                        BookItemInGrid(book: book)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .onTapGesture {
                                selectedBookViewModel.selectedBook = book // on tap open the description of the book
                            }
                            .padding(5)
                            .contextMenu {
                                // Button to move to the current book to the finished books list
                                Button {
                                    withAnimation{
                                        selectedTabInLibrary = .finishedBooks
                                        
                                        // Search the book index
                                        if let bookIndex = readingListBooks.firstIndex(where: {$0.id == book.id}){
                                            // Change the date so is the first one on the list
                                            readingListBooks[bookIndex].addedDate = Date.now
                                            
                                            // Change the list
                                            readingListBooks[bookIndex].list = "finishedList"
                                        }
                                    }
                                } label: {
                                    Label("Move to finished books", systemImage: "arrow.right")
                                }
                                
                                // Button to remove the book
                                Button(role: .destructive) {
                                    if let id = book.id, let title = book.title {
                                        dialogDetail = BookDetails(id: id, title: title)
                                    }
                                    isConfirming = true
                                } label: {
                                    Label("Remove book", systemImage: "trash")
                                }
                            }
                            // Confirmation dialog to ensure that the user really wants to delete the selected book
                            .confirmationDialog(
                                "Are you sure you want to delete this book?",
                                isPresented: $isConfirming, titleVisibility: .visible, presenting: dialogDetail
                            ) { detail in
                                Button(role: .destructive) {
                                    
                                    // Add book id to the deletedBooks id (this is stored in the user defaults)
                                    deletedBooksIDs.append(detail.id)
                                    defaults.set(deletedBooksIDs, forKey: "deletedIDs")
                                    
                                    // Delete the book
                                    if let bookIndex = readingListBooks.firstIndex(where: {$0.id == detail.id}){
                                        withAnimation{
                                            modelContext.delete(readingListBooks[bookIndex])
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
                // If the reading list is empty show a message to the user
                if readingListBooks.isEmpty{
                    ContentUnavailableView("Looks like your reading list is pretty empty", systemImage: "bookmark.fill", description: Text("Let's fill it up! Head to the discover page to find some great reads, or simply tap the + to add books"))
                }
            }
            // Open the description of the book in full screen
            .fullScreenCover(item: $selectedBookViewModel.selectedBook){ fullScreenBook in
                BookDescriptionView(book: fullScreenBook, showOptions: true, selectedTabInLibrary: $selectedTabInLibrary, tabSelection: $tabSelection, showActionButton: false)
            }
        }
        .onAppear{
            // Get the ids of the deleted books
            deletedBooksIDs = (defaults.array(forKey: "deletedIDs") ?? []) as? [String] ?? [""]
        }
    }
}

#Preview {
    ReadingListView(selectedTabInLibrary: .constant(.readingList), tabSelection: .constant(2))
}
