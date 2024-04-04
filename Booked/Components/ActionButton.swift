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
    
    @State var icon: String?
    @State var label: String
    @State var isInBookDescription: Bool
    
    var body: some View {
        
        HStack(spacing: 10){
            if let icon = icon {
                Image(systemName: icon)
            }
            
            Text(label)
                
        }
        .font(.subheadline)
        .foregroundStyle(.white)
        .bold()
        .padding()
        .padding(.horizontal)
        .background(.ultraThinMaterial.opacity(isInBookDescription ? 1.0 : 0.0))
        .background(colorScheme == .light ? Color(hex: "#848489") : (Color(hex: "#818181")).opacity(isInBookDescription ? 0.0 : 1.0))
        .clipShape(Capsule())
    }
}

#Preview {
    ActionButton(icon: "bookmark", label: "Add to reading list", isInBookDescription: true)
}
