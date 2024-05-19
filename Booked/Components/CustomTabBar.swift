//
//  CustomTabBar.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct CustomTabBar: View {
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    @Binding var selectedTab: Tab?
    @Binding var tabProgress: CGFloat
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 0){
            
            // For each to display all the tabs that are created
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10){
                    // Icon of the tab
                    Image(systemName: tab.systemImage)
                    
                    // Label of the tab
                    Text(tab.rawValue)
                        .font(.footnote)
                }
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation(.snappy){
                        selectedTab = tab
                    }
                }
                .sensoryFeedback(.increase, trigger: selectedTab)
            }
        }
        .tabMask(tabProgress)
        .background{ // This part is for the capsule that moves dependind on the selected tab
            GeometryReader{ geo in
                let size = geo.size
                let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(Color.secondary)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
        }
        .padding(5)
        .background(.thinMaterial, in: .capsule)
        .overlay{
            Capsule()
                .stroke(.primary.opacity(0.2), lineWidth: 0.5)
        }
        .padding(.horizontal)
        .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0.0), radius: 25, x: 0, y: 8)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.finishedBooks), tabProgress: .constant(0))
}
