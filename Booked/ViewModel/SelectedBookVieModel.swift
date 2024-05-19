//
//  TestViewModel.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 29/03/24.
//

import Foundation

final class SelectedBookVieModel: ObservableObject{
    @Published var selectedBook: Book? // Get anytime the book that has been selected
}
