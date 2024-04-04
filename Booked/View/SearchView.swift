//
//  SearchView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    @Query private var items: [Book]
    
    // MARK: - ViewModels
    @StateObject var searchViewModel = SearchViewModel()
    
    @State var list: String
    
    var body: some View {
        NavigationStack{
            
            ScrollView{
                LazyVStack(spacing: 15){
                    if searchViewModel.searchTerm != "" {
                        ForEach(searchViewModel.books) { book in
                            
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
                if searchViewModel.searchTerm.isEmpty {
                    ContentUnavailableView(label: {
                        Label("Search your favorites books or authors", systemImage: "book.closed.fill")
                    })
                }
            }
            .searchable(text: $searchViewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchViewModel.searchTerm) {
                // Everytime the user type perform the search
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
    
    func searchByID(with bookSearched: BookLocal) -> Bool{
        return (items.first { book in
            book.id == bookSearched.id && book.list != "recommendList"
        } != nil)
    }
}

#Preview {
    SearchView(list: "finishedBook")
}
