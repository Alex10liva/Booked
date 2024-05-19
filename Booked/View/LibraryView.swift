//
//  LibraryView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Properties
    @State private var isAddSheetDisplayed: Bool = false
    @State private var tabProgress: CGFloat = 0
    @Binding var selectedTabInLibrary: Tab?
    @Binding var tabSelection: Int
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                GeometryReader{ geo in
                    
                    let size = geo.size // Size of the geometry reader
                    
                    // Scroll view to have the option to drag to change between reading list and finished list
                    ScrollView(.horizontal){
                        LazyHStack(spacing: 0){
                            ReadingListView(selectedTabInLibrary: $selectedTabInLibrary, tabSelection: $tabSelection)
                                .id(Tab.readingList)
                                .containerRelativeFrame(.horizontal)
                            
                            FinishedListView(selectedTabInLibrary: $selectedTabInLibrary, tabSelection: $tabSelection)
                                .id(Tab.finishedBooks)
                                .containerRelativeFrame(.horizontal)
                        }
                        .scrollTargetLayout()
                        .offsetX{ value in
                            let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                            tabProgress = max(min(progress, 1), 0) // Get the progress of the scrolling tab in library
                        }
                    }
                    .scrollPosition(id: $selectedTabInLibrary)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                }
                
                VStack{
                    CustomTabBar(selectedTab: $selectedTabInLibrary, tabProgress: $tabProgress)
                        .padding(.top, 10)
                        .padding(.bottom, 45)
                        .background(
                            Rectangle()
                                .fill(
                                    // Change the color of the custom tab bar depending on the selected tab (reading list or finished books)
                                    Color(
                                        red: (1 - tabProgress) * 0.29 + tabProgress * 1.0,
                                        green: (1 - tabProgress) * 0.0 + tabProgress * 0.0,
                                        blue: (1 - tabProgress) * 1.0 + tabProgress * 0.55
                                    )
                                    .opacity(0.3)
                                )
                                .fill(.thinMaterial)
                                .mask {
                                    // Add a gradient from thinMaterial to clear
                                    VStack(spacing: 0) {
                                        Rectangle()
                                        LinearGradient(
                                            colors: [
                                                Color.black.opacity(1),
                                                Color.black.opacity(0),
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    }
                                }
                                .overlay{
                                    // Image to add a little bit of grain to the background of the custom tab bar
                                    Image("grain")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .opacity(0.2)
                                        .overlay{
                                            colorScheme == .light ? Color.white.opacity(0.2) : Color.black.opacity(0.5)
                                        }
                                        .mask(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.black.opacity(0.7), .black.opacity(0)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .ignoresSafeArea()
                                }
                                .ignoresSafeArea()
                        )
                    Spacer()
                }
                
            }
            .navigationTitle("Library")
            .toolbarTitleDisplayMode(.inline)
            
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    
                    // Menu to show two buttons
                    Menu {
                        // Button to open the search view to add a new book in the reading list
                        Button{
                            if self.selectedTabInLibrary != .readingList {
                                // If the selected tab is not the reading list change to the reading list
                                withAnimation {
                                    self.selectedTabInLibrary = .readingList
                                }
                                
                                // And open the search view with a delay of 0.3s
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.isAddSheetDisplayed.toggle()
                                }
                            } else {
                                // Open the search view
                                self.isAddSheetDisplayed.toggle()
                            }
                        } label: {
                            Image(systemName: "bookmark.fill")
                            Text("Add to reading list")
                        }
                        
                        // Button to open the search view to add a new book in the finished books list
                        Button{
                            if self.selectedTabInLibrary != .finishedBooks {
                                // If the selected tab is not the finished books list change to the finished books list
                                withAnimation {
                                    self.selectedTabInLibrary = .finishedBooks
                                }
                                
                                // And open the search view with a delay of 0.3s
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.isAddSheetDisplayed.toggle()
                                }
                            } else {
                                // Open the search view
                                self.isAddSheetDisplayed.toggle()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                            Text("Add to finished books")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .bold()
                    .foregroundStyle(Color.accent)
                    .sheet(isPresented: $isAddSheetDisplayed){
                        // Open the search view passing the selected list to add a new book to this list
                        SearchView(list: selectedTabInLibrary == .readingList ? "readingList" : "finishedList")
                    }
                }
            }
        }
    }
}

#Preview {
    LibraryView(selectedTabInLibrary: .constant(.readingList), tabSelection: .constant(2))
}
