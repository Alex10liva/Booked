//
//  View+Extensions.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View{
    
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay{
                GeometryReader{ geo in
                    let minX = geo.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
    
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack{
            self
                .foregroundStyle(.secondary)
            
            self
                .symbolVariant(.fill)
                .mask{
                    GeometryReader{ geo in
                        let size = geo.size
                        let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                        
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: tabProgress * (size.width - capsuleWidth))
                    }
                }
        }
    }
}
