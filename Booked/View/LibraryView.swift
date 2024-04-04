//
//  LibraryView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData

enum ListOrder{
    case dateAscending
    case dateDescending
    case titleAscending
    case titleDescending
    case authorAshending
    case authorDescending
}

struct LibraryView: View {
    
    @State private var isAddSheetDisplayed: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tab?
    @Binding var tabSelection: Int
    @State private var tabProgress: CGFloat = 0
    @State private var addToListName: String = ""
    @State var selectedListOrder: ListOrder = .dateDescending
    
    var body: some View {
        NavigationStack{
            
            ZStack(alignment: .top){
                GeometryReader{ geo in
                    
                    let size = geo.size
                    
                    ScrollView(.horizontal){
                        
                        LazyHStack(spacing: 0){
                            ReadingListView(selectedTab: $selectedTab, tabSelection: $tabSelection, selectedListOrder: $selectedListOrder)
                                .id(Tab.readingList)
                                .containerRelativeFrame(.horizontal)
                            
                            FinishedListView(selectedTab: $selectedTab, tabSelection: $tabSelection, selectedListOrder: $selectedListOrder)
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
                        .padding(.bottom, 45)
                        .background(
                            Rectangle()
                                .fill(
                                    Color(
                                        red: (1 - tabProgress) * 0.29 + tabProgress * 1.0,
                                        green: (1 - tabProgress) * 0.0 + tabProgress * 0.0,
                                        blue: (1 - tabProgress) * 1.0 + tabProgress * 0.55
                                    )
                                    .opacity(0.3)
                                )
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
                                .overlay{
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
            }
        }
    }
}

#Preview {
    LibraryView(selectedTab: .constant(.readingList), tabSelection: .constant(2))
}
