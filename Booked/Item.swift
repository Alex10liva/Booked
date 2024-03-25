//
//  Item.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
