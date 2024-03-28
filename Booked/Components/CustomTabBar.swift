//
//  CustomTabBar.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tab?
    @Binding var tabProgress: CGFloat
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10){
                    Image(systemName: tab.systemImage)
                    
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
        .background{
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
        .padding(.horizontal)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.finishedBooks), tabProgress: .constant(0))
}
