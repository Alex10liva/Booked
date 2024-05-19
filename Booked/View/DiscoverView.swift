//
//  DiscoverView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct DiscoverView: View {
    
    // MARK: - Environment properties
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Swift data queries
    // Filter the books that are in the recommendList
    @Query(filter: #Predicate<Book> { book in
        book.list == "recommendList"
    }, sort: \Book.averageRating, order: .reverse) private var books: [Book]
    
    // MARK: - Properties
    @State var selectedBook: Book?
    @Binding var tabSelection: Int
    @Binding var selectedTabInLibrary: Tab?
    
    var body: some View {
        NavigationStack{
            //Shows the recommended books as long as the list is not empty
            if !books.isEmpty {
                VStack{
                    // Horizontal scroll view to show all the books
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(alignment: .center){
                            // Show the 10 most relevant books
                            ForEach(books.prefix(10), id: \.self) { book in
                                SingleBookCard(bookInfo: book, tabSelection: $tabSelection)
                                    .containerRelativeFrame(.horizontal)
                                    .scrollTransition { content, phase in
                                        content // Do this transition everytime you scroll to another book
                                            .opacity(phase.isIdentity ? 1 : 0.5)
                                            .scaleEffect(phase.isIdentity ? 1 : 0.6)
                                    }
                            }
                        }
                        .scrollTargetLayout()
                        .sensoryFeedback(.increase, trigger: selectedBook)
                    }
                    .scrollClipDisabled()
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $selectedBook)
                    .onAppear{
                        if !books.isEmpty {
                            selectedBook = books[0] // Set the first book to the selected book on appear
                        }
                    }
                    
                    // Cirlces to indicate the active book
                    HStack{
                        // Show the 10 most relevant books
                        ForEach(books.prefix(10).indices, id: \.self){ index in
                            if let selectedBook, let selectedBookIndex = books.firstIndex(of: selectedBook){
                                Circle()
                                    .fill(selectedBookIndex == index ? Color.primary : Color.secondary.opacity(0.6))
                                    .frame(height: 5)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                    ZStack{
                        Capsule()
                            .fill(.thinMaterial)
                            .frame(height: 60)
                        
                        HStack{
                            // Left arrow to move the index of the scroll view to the left
                            Button {
                                guard let selectedBook, let index = books.firstIndex(of: selectedBook), index > 0 else { return }
                                
                                withAnimation{
                                    self.selectedBook = books[index - 1]
                                }
                            } label: {
                                Image(systemName: "arrow.left")
                                    .bold()
                                    .foregroundStyle(.primary.opacity(selectedBook == Array(books.prefix(10)).first ? 0.3 : 1.0))
                            }
                            .disabled(selectedBook == Array(books.prefix(10)).first)
                            .padding(5)
                            
                            Spacer()
                            
                            // Action button that opens a menu to add the current book to the selected list
                            Menu {
                                Button{
                                    if let selectedBook = self.selectedBook{
                                        addItem(with: selectedBook, listToSave: "finishedList")
                                    }
                                } label: {
                                    Label("Finished books", systemImage: "checkmark")
                                }
                                
                                Button{
                                    if let selectedBook = self.selectedBook {
                                        addItem(with: selectedBook, listToSave: "readingList")
                                    }
                                } label: {
                                    Label("Reading list", systemImage: "bookmark")
                                }
                                
                            } label: {
                                ActionButton(icon: "plus", label: "Add to my library", isInBookDescription: false)
                            }
                            
                            Spacer()
                            
                            // Right arrow to move the index of the scroll view to the right
                            Button {
                                guard let selectedBook, let index = books.firstIndex(of: selectedBook), index < books.count - 1 else { return }
                                
                                withAnimation{
                                    self.selectedBook = books[index + 1]
                                }
                            } label: {
                                Image(systemName: "arrow.right")
                                    .bold()
                                    .foregroundStyle(.primary.opacity(selectedBook == Array(books.prefix(10)).last ? 0.3 : 1.0))
                            }
                            .disabled(selectedBook == Array(books.prefix(10)).last)
                            .padding(5)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            } else {
                // If the recommend list is empty show a message so the user know what to do
                ContentUnavailableView("Oops! No recommendations yet",
                                       systemImage: "sparkle.magnifyingglass",
                                       description: Text("Start adding books to the finished books list to receive personalized recommendations"))
            }
        }
        
    }
    
    // Function to add a book in the given list
    private func addItem(with book: Book, listToSave: String) {
        withAnimation{
            if let bookIndex = books.firstIndex(where: {$0.id == book.id}){
                books[bookIndex].addedDate = Date.now
                books[bookIndex].list = listToSave
            }
            
            // change the tab to move to library view
            self.tabSelection = 2
            
            // Change the selected tab in library where the user added the book
            self.selectedTabInLibrary = listToSave == "finishedList" ? .finishedBooks : .readingList
        }
    }
}

#Preview {
    DiscoverView(tabSelection: .constant(1), selectedTabInLibrary: .constant(.finishedBooks))
}
