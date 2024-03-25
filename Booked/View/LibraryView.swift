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
    @State private var selectedTab: Tab? = .readingList
    @State private var tabProgress: CGFloat = 0
    
    var body: some View {
        NavigationStack{
            
            ZStack(alignment: .bottom){
                
                GeometryReader{ geo in
                    
                    let size = geo.size
                    
                    ScrollView(.horizontal){
                        LazyHStack(spacing: 0){
                            ReadingListView()
                                .id(Tab.readingList)
                                .containerRelativeFrame(.horizontal)
                            
                            FinishedListView()
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
                
                CustomTabBar(selectedTab: $selectedTab, tabProgress: $tabProgress)
                    .padding()
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Text(selectedTab == .readingList ? "Reading List" : "Finished Books")
                        .font(.title)
                        .bold()
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    
                    HStack{
                        Button{
                            print("Pressed filter")
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.callout)
                        }
                        .foregroundStyle(Color.accent)
                        
                        Button{
                            isAddSheetDisplayed.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline)
                        }
                        .foregroundStyle(Color.accent)
                        .sheet(isPresented: $isAddSheetDisplayed){
                            SearchView(list: selectedTab == .readingList ? "readingList" : "finishedList")
                        }
                    }
                    
                    .bold()
                }
            }
        }
        
    }
}

#Preview {
    LibraryView()
}
