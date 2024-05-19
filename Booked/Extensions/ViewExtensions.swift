//
//  ViewExtensions.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 02/04/24.
//

import Foundation
import SwiftUI

// Scroll offset to know when the user does a scroll
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}
