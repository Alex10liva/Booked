//
//  Item.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import Foundation
import SwiftData

enum ListType: Codable{
    case readingList
    case finishedList
}

@Model
final class Book {
    var id: String?
    var title: String?
    var authors: [String]?
    var publisher: String?
    var publishedDate: String?
    var descriptionStored: String?
    var imageLinks: ImageLinks?
    var categories: [String]? // Categorías del libro
    var averageRating: Double? // Calificación promedio del libro
    var ratingsCount: Int? // Número de calificaciones recibidas
    var pageCount: Int? // Número de páginas del libro
    var language: String? // Idioma del libro
    var previewLink: String? // Enlace de vista previa del libro
    var infoLink: String? // Enlace de información adicional sobre el libro
    var list: ListType
    var addedDate: Date?
    
    init(id: String?, title: String?, authors: [String]?, publisher: String?, publishedDate: String?, descriptionStored: String?, imageLinks: ImageLinks?, categories: [String]?, averageRating: Double?, ratingsCount: Int?, pageCount: Int?, language: String?, previewLink: String?, infoLink: String?, list: ListType, addedDate: Date?) {
        self.id = id
        self.title = title
        self.authors = authors
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.descriptionStored = descriptionStored
        self.imageLinks = imageLinks
        self.categories = categories
        self.averageRating = averageRating
        self.ratingsCount = ratingsCount
        self.pageCount = pageCount
        self.language = language
        self.previewLink = previewLink
        self.infoLink = infoLink
        self.list = list
        self.addedDate = addedDate
    }
}

// MARK: - Struct of book
struct BookLocal: Identifiable{
    let id: String?
    let title: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let descriptionStored: String?
    let imageLinks: ImageLinks?
    let categories: [String]? // Categorías del libro
    let averageRating: Double? // Calificación promedio del libro
    let ratingsCount: Int? // Número de calificaciones recibidas
    let pageCount: Int? // Número de páginas del libro
    let language: String? // Idioma del libro
    let previewLink: String? // Enlace de vista previa del libro
    let infoLink: String? // Enlace de información adicional sobre el libro
}

// MARK: - Struct to decode the received book from the API
struct BookResponse: Codable {
    let items: [BookItem]
}

// MARK: - Struct of the received book from the API
struct BookItem: Codable {
    let id: String?
    let volumeInfo: VolumeInfo
}

// MARK: - Struct of the volume info of the book
struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let imageLinks: ImageLinks?
    let categories: [String]? // Categorías del libro
    let averageRating: Double? // Calificación promedio del libro
    let ratingsCount: Int? // Número de calificaciones recibidas
    let pageCount: Int? // Número de páginas del libro
    let language: String? // Idioma del libro
    let previewLink: String? // Enlace de vista previa del libro
    let infoLink: String? // Enlace de información adicional sobre el libro
}

// MARK: - Struct of the image links of the book
struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
    let small: String?
    let medium: String?
    let large: String?
    let extraLarge: String?
}
