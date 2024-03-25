//
//  BookItemInGrid.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct BookItemInGrid: View {
    var body: some View {
        VStack (alignment: .leading){
            Image("harry")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Text("Harry Potter and the Philosopher’s Stone")
                .font(.subheadline)
                .lineLimit(2)
            
            Text("J. K. Rowling ")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}

#Preview {
    BookItemInGrid()
}
