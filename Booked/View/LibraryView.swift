//
//  LibraryView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct LibraryView: View {
    
    @State private var isAddSheetDisplayed: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTab: Tab? = .readingList
    @State private var tabProgress: CGFloat = 0
    @State private var addToListName: String = ""
    
    var body: some View {
        NavigationStack{
            
            ZStack(alignment: .top){
                GeometryReader{ geo in
                    
                    let size = geo.size
                    
                    ScrollView(.horizontal){
                        
                        LazyHStack(spacing: 0){
                            ReadingListView(selectedTab: $selectedTab)
                                .id(Tab.readingList)
                                .containerRelativeFrame(.horizontal)
                            
                            FinishedListView(selectedTab: $selectedTab)
                                .id(Tab.finishedBooks)
                                .containerRelativeFrame(.horizontal)
                        }
                        .scrollTargetLayout()
                        .offsetX{ value in
                            let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                            tabProgress = max(min(progress, 1), 0)
                        }
                    }
                    .scrollPosition(id: $selectedTab)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                }
                
                VStack{
                    CustomTabBar(selectedTab: $selectedTab, tabProgress: $tabProgress)
                        .padding(.top, 10)
                        .padding(.bottom, 55)
                        .background(
                            Rectangle()
                            
                                .fill(.thinMaterial)
                            
                                .mask {
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
                                .ignoresSafeArea()
                        )
                    Spacer()
                    Divider()
                }
                
            }
            .navigationTitle("Library")
            .toolbarTitleDisplayMode(.inline)
            
            .toolbar{
                
                ToolbarItem(placement: .topBarTrailing){
                    Menu {
                        Button{
                            if self.selectedTab != .readingList {
                                withAnimation {
                                    self.selectedTab = .readingList
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.isAddSheetDisplayed.toggle()
                                }
                            } else {
                                self.isAddSheetDisplayed.toggle()
                            }
                        } label: {
                            Image(systemName: "bookmark.fill")
                            Text("Add to reading list")
                        }
                        
                        Button{
                            if self.selectedTab != .finishedBooks {
                                withAnimation {
                                    self.selectedTab = .finishedBooks
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.isAddSheetDisplayed.toggle()
                                }
                            } else {
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
                        SearchView(list: selectedTab == .readingList ? "readingList" : "finishedList")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading){
                    Menu{
                        Button{
                            print("Pressed filter")
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.callout)
                        }
                        
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .bold()
                    .foregroundStyle(Color.accent)
                }
                
                
            }
        }
    }
}

#Preview {
    LibraryView()
}
