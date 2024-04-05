//
//  DiscoverView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct DiscoverView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Book> { book in
        book.list == "recommendList"
    }, sort: \Book.averageRating, order: .reverse) private var books: [Book]
    
    @State var selectedBook: Book?
    @Binding var tabSelection: Int
    @Binding var selectedTab: Tab?
    
    var body: some View {
        NavigationStack{
            
            if !books.isEmpty {
                VStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(alignment: .center){
                            ForEach(books.prefix(10), id: \.self) { book in
                                SingleBookCard(bookInfo: book, tabSelection: $tabSelection)
                                    .containerRelativeFrame(.horizontal)
                                    .scrollTransition { content, phase in
                                        content
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
                            selectedBook = books[0]
                        }
                    }
                    
                    HStack{
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
                ContentUnavailableView("Oops! No recommendations yet",
                                       systemImage: "sparkle.magnifyingglass",
                                       description: Text("Start adding books to the finished books list to receive personalized recommendations"))
            }
        }
        
    }
    
    private func addItem(with book: Book, listToSave: String) {
        withAnimation{
            if let bookIndex = books.firstIndex(where: {$0.id == book.id}){
                books[bookIndex].addedDate = Date.now
                books[bookIndex].list = listToSave
            }
            self.tabSelection = 2
            self.selectedTab = listToSave == "finishedList" ? .finishedBooks : .readingList
        }
    }
}

#Preview {
    DiscoverView(tabSelection: .constant(1), selectedTab: .constant(.finishedBooks))
}
