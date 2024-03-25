//
//  ReadingListView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct ReadingListView: View {
    
    @State private var isAddSheetDisplayed: Bool = false
    @State private var orderedBooks: [Book] = []
    
    var body: some View {
        NavigationStack {
            
            ScrollView(showsIndicators: false){
                LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 24),
                        GridItem(.flexible(), spacing: 24)
                ], spacing: 15){
                    BookItemInGrid()
                    BookItemInGrid()
                    BookItemInGrid()
                    
                }
                .padding()
                
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Text("Reading List")
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
                    }
                    
                    .bold()
                }
            }
        }
    }
}

#Preview {
    ReadingListView()
}
