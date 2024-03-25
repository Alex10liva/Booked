//
//  ActionButton.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

import SwiftUI

struct ActionButton: View {
    
    // MARK: - Enviroment properties
    @Environment(\.colorScheme) var colorScheme
    
    @State var icon: String
    @State var label: String
    @State var action: (() -> Void)?
    
    var body: some View {
        
        if let receivedAction = action{
            Button(action: receivedAction){
                
                HStack(spacing: 10){
                    Image(systemName: icon)
                    
                    Text(label)
                        
                }
            }
            .font(.subheadline)
            .foregroundStyle(.white)
            .bold()
            .padding()
            .padding(.horizontal)
            .background(colorScheme == .light ? Color.secondary : Color(hex: "#818181"))
            .clipShape(Capsule())
        }
    }
}

#Preview {
    ActionButton(icon: "bookmark", label: "Add to reading list"){
        print("Hello world")
    }
}
