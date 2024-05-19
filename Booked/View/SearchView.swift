//
//  SearchView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    // MARK: - Swift data queries
    // Get all the books
    @Query private var items: [Book]
    
    // MARK: - View Model
    @StateObject var searchViewModel = SearchViewModel()
    
    // MARK: - Properties
    @State var list: String
    @State private var isSearchFieldFocused = true
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(spacing: 15){
                    
                    // If the searhc term is not empty
                    if searchViewModel.searchTerm != "" {
                        // Display the search results
                        ForEach(searchViewModel.books) { book in
                            // Show only books that are not in any list
                            if !searchByID(with: book){
                                BookItemInSearch(bookLocal: book, list: self.list)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
            .scrollDismissesKeyboard(.immediately)
            .overlay{
                // If the search term is empy show a message to the user
                if searchViewModel.searchTerm.isEmpty {
                    ContentUnavailableView(label: {
                        Label("Search your favorites books or authors", systemImage: "book.closed.fill")
                    })
                }
            }
            .searchable(text: $searchViewModel.searchTerm, isPresented: $isSearchFieldFocused, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchViewModel.searchTerm) {
                searchViewModel.fetchBooks(with: searchViewModel.searchTerm)
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text(list == "readingList" ? "Add to reading list" : "Add to finished books")
                        .bold()
                }
            }
        }
    }
    
    // MARK: - Functions
    // Function to filter the books that are not already in any list
    func searchByID(with bookSearched: BookLocal) -> Bool{
        return (items.first { book in
            book.id == bookSearched.id && book.list != "recommendList"
        } != nil)
    }
}

#Preview {
    SearchView(list: "finishedBook")
}
