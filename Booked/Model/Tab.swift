//
//  Tabs.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import Foundation

// MARK: - Enum to define the tabs in the application
enum Tab: String, CaseIterable {
    case readingList = "Reading List"
    case finishedBooks = "Finished Books"
    
    var systemImage: String {
        switch self {
        case .readingList:
            "bookmark.fill"
        case .finishedBooks:
            "checkmark"
        }
    }
}
