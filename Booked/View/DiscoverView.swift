//
//  DiscoverView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        VStack{
            SingleBookCard()
            
            ActionButton(icon: "bookmark", label: "Add to reading list"){
                print("button pressed")
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    DiscoverView()
}
