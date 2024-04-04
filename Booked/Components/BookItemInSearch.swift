//
//  BookItemInSearch.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import SwiftData
import Kingfisher

struct BookItemInSearch: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Book> { book in
        book.list == "recommendList"
    }, sort: \Book.addedDate, order: .reverse) private var recommendedBooks: [Book]
    
    @Query(filter: #Predicate<Book> { book in
        book.list == "finishedList"
    }, sort: \Book.addedDate, order: .reverse) private var finishedBooks: [Book]
    
    @Query(filter: #Predicate<Book> { book in
        book.list == "readingList"
    }, sort: \Book.addedDate, order: .reverse) private var readingBooks: [Book]
    
    @Query private var items: [Book]
    
    @Environment(\.dismiss) var dismiss
    
    @State var bookLocal: BookLocal
    @State var imageLoaded: Bool = false
    @State var imageURLs: [String] = []
    @State var list: String
    @State var sendHapticFeedback: Bool = false
    let webService = WebService()
    @State private var lastXAuthors: [String] = []
    let defaults = UserDefaults.standard
    @State var deletedBooksIDs: [String] = []
    
    var body: some View {
        HStack{
            
            if let extraLarge = bookLocal.imageLinks?.extraLarge{
                KFImage(URL(string: extraLarge))
                    .onSuccess{ result in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)){
                            imageLoaded = true
                        }
                    }
                    .placeholder { progress in
                        Rectangle()
                            .fill(.primary.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: 60, height: 90)
                            .overlay{
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                            .padding(.leading)
                            .padding(.trailing)
                    }
                    .fade(duration: 0.5)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 60)
                    .padding(.trailing)
            } else {
                if let id = bookLocal.id {
                    KFImage(URL(string: "https://books.google.com/books/publisher/content/images/frontcover/\(id)?fife=w1200&source=gbs_api"))
                        .onSuccess{ result in
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)){
                                imageLoaded = true
                            }
                        }
                        .placeholder { progress in
                            Rectangle()
                                .fill(.primary.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .frame(width: 60, height: 90)
                                .overlay{
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                                .padding(.leading)
                                .padding(.trailing)
                        }
                        .fade(duration: 0.5)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(width: 60)
                        .padding(.trailing)
                }
            }
            
            VStack(alignment: .leading){
                
                if let title = bookLocal.title{
                    Text(title)
                        .font(.subheadline)
                        .lineLimit(2)
                        .bold()
                }
                
                if let authors = bookLocal.authors{
                    Text(concatAuthors(for: authors))
                        .font(.footnote)
                        .lineLimit(2)
                }
                
                if let averageRating = bookLocal.averageRating {
                    HStack(spacing: 5){
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .bold()
                        
                        Text(String(averageRating))
                        
                        if let ratingsCount = bookLocal.ratingsCount {
                            Text("(\(String(ratingsCount)))")
                                .foregroundStyle(.secondary.opacity(0.6))
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            Spacer()
            
            Button{
                addItem(with: self.bookLocal)
                sendHapticFeedback.toggle()
                dismiss()
            } label: {
                Image(systemName: "plus.circle")
                    .font(.title3)
                    .fontWeight(.regular)
            }
            .sensoryFeedback(.increase, trigger: sendHapticFeedback)
        }
        .onAppear{
            deletedBooksIDs = (defaults.array(forKey: "deletedIDs") ?? []) as? [String] ?? [""]
        }
    }
    
    private func addItem(with book: BookLocal) {
        
        let bookToSave = Book(id: book.id, title: book.title, authors: book.authors, publisher: book.publisher, publishedDate: book.publishedDate, descriptionStored: book.descriptionStored, imageLinks: book.imageLinks, categories: book.categories, averageRating: book.averageRating, ratingsCount: book.ratingsCount, pageCount: book.pageCount, language: book.language, previewLink: book.previewLink, infoLink: book.infoLink, list: self.list, addedDate: Date.now)
        
        withAnimation {
            let newItem = bookToSave
            modelContext.insert(newItem)
        }
        
        if self.list == "finishedList" {
            
            do {
                try modelContext.delete(
                    model: Book.self,
                    where: #Predicate { item in
                        item.list == "recommendList"
                    }
                )
            } catch {
                print("Error al eliminar libros recomendados existentes: \(error)")
            }
            
            let authorsQuery = finishedBooks.flatMap { $0.authors ?? [] }
            
            let lastXAuthorsCount = 5
            getLastXAuthors(from: authorsQuery, count: lastXAuthorsCount)
            
            for author in lastXAuthors {
                let query = "https://www.googleapis.com/books/v1/volumes?q=inauthor:\(author)&orderBy=relevance&maxResults=10"
                Task {
                    guard let bookResponse: BookResponse = await webService.downloadData(fromURL: query) else {
                        print("No se pudo obtener una respuesta de la API de Google Books.")
                        return
                    }
                    
                    handleBookResponse(bookResponse: bookResponse)
                }
            }
        }
    }
    
    func concatAuthors(for authors: [String]) -> String {
        guard !authors.isEmpty else { return "" }
        
        if authors.count == 1 {
            return authors[0]
        } else {
            let allButLast = authors.dropLast().joined(separator: ", ")
            let last = authors.last
            return "\(allButLast) & \(last ?? "")"
        }
    }
    
    func convertToSecureURL(urlString: String) -> String {
        if urlString.hasPrefix("http://") {
            let secureURLString = urlString.replacingOccurrences(of: "http://", with: "https://")
            return secureURLString
        } else {
            return urlString
        }
    }
    
    func getLastXAuthors(from authors: [String], count: Int) {
        guard authors.count >= count else {
            lastXAuthors = authors
            return
        }
        
        let startIndex = authors.count - count
        let endIndex = authors.count
        lastXAuthors = Array(authors[startIndex..<endIndex])
    }
    
    func getBookKeyPoints(from books: [Book]) -> [String: Any] {
        var keyPoints: [String: Any] = [:]
        
        var genres: [String] = []
        var authors: [String] = []
        var keywords: [String] = []
        
        for book in books {
            if let bookGenres = book.categories {
                genres.append(contentsOf: bookGenres)
            }
            if let bookAuthors = book.authors {
                authors.append(contentsOf: bookAuthors)
            }
            if let bookTitle = book.title {
                keywords.append(bookTitle)
            }
        }
        
        keyPoints["genres"] = Array(Set(genres))
        keyPoints["authors"] = Array(Set(authors))
        
        return keyPoints
    }
    
    func handleBookResponse(bookResponse: BookResponse) {
        DispatchQueue.main.async {
            
            bookResponse.items.forEach { item in
                let id = item.id
                let title = item.volumeInfo.title
                let authors = item.volumeInfo.authors
                let publisher = item.volumeInfo.publisher
                let publishedDate = item.volumeInfo.publishedDate
                let description = item.volumeInfo.description
                let imageLinks = item.volumeInfo.imageLinks
                let categories = item.volumeInfo.categories
                let averageRating = item.volumeInfo.averageRating
                let ratingsCount = item.volumeInfo.ratingsCount
                let pageCount = item.volumeInfo.pageCount
                let language = item.volumeInfo.language
                let previewLink = item.volumeInfo.previewLink
                let infoLink = item.volumeInfo.infoLink
                
                guard let id = id, let title = title, let authors = authors, let publisher = publisher, let publishedDate = publishedDate, let description = description, let imageLinks = imageLinks else { return }
                
                if deletedBooksIDs.contains(where: {$0 == id }){
                    print("El libro se borro con anterioridad")
                    return
                }
                
                if recommendedBooks.contains(where: { $0.id == id }) {
                    print("El libro con ID \(id) ya está en la lista de recomendaciones.")
                    return
                }
                
                if readingBooks.contains(where: {$0.id == id}) || finishedBooks.contains(where: ({$0.id == id})){
                    print("El libro con ID \(id) ya esta agregado")
                    return
                }
                
                let newBook = Book(
                    id: id,
                    title: title,
                    authors: authors,
                    publisher: publisher,
                    publishedDate: publishedDate,
                    descriptionStored: description,
                    imageLinks: imageLinks,
                    categories: categories,
                    averageRating: averageRating,
                    ratingsCount: ratingsCount,
                    pageCount: pageCount,
                    language: language,
                    previewLink: previewLink,
                    infoLink: infoLink,
                    list: "recommendList",
                    addedDate: Date.now
                )
                modelContext.insert(newBook)
            }
        }
    }
}

#Preview {
    BookItemInSearch(bookLocal: BookLocal(id: "", title: "", authors: [""], publisher: "", publishedDate: "", descriptionStored: "", imageLinks: nil, categories: [""], averageRating: 0.0, ratingsCount: 10, pageCount: 10, language: "", previewLink: "", infoLink: ""), list: "finishedBook")
}

