//
//  SearchView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - ViewModels
    @StateObject var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack{
            
            ScrollView{
                LazyVStack(spacing: 15){
                    if searchViewModel.searchTerm != "" {
                        ForEach(searchViewModel.books) { book in
                            BookItemInSearch(book: book)
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
                    Text("Select book")
                        .bold()
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
