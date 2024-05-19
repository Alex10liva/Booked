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
    // MARK: - Environment properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Swift data queries
    // Filter the books that are in the recommendList
    @Query(filter: #Predicate<Book> { book in
        book.list == "recommendList"
    }, sort: \Book.addedDate, order: .reverse) private var recommendedBooks: [Book]
    
    // Filter the books that are in the finishedList
    @Query(filter: #Predicate<Book> { book in
        book.list == "finishedList"
    }, sort: \Book.addedDate, order: .reverse) private var finishedBooks: [Book]
    
    // Filter the books that are in the readingList
    @Query(filter: #Predicate<Book> { book in
        book.list == "readingList"
    }, sort: \Book.addedDate, order: .reverse) private var readingBooks: [Book]
    
    // MARK: - Properties
    let webService = WebService()
    let defaults = UserDefaults.standard
    @State var bookLocal: BookLocal
    @State var list: String
    @State private var sendHapticFeedback: Bool = false
    @State private var lastXAuthors: [String] = []
    @State private var deletedBooksIDs: [String] = []
    
    // MARK: - Body
    var body: some View {
        HStack{
            // If the book has large image display it
            if let extraLarge = bookLocal.imageLinks?.large{
                KFImage(URL(string: extraLarge))  /// king fisher (library for downloading and caching images from the web)
                    .placeholder { progress in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.primary.opacity(0.3))
                            .frame(width: 60, height: 90)
                            .overlay{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.primary.opacity(0.4), lineWidth: 2)
                                    
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                            }
                            .padding(.horizontal)
                    }
                    .fade(duration: 0.5)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 60)
                    .padding(.trailing)
            } else {
                // Use the id of the book to get the front cover with a width of 500
                if let id = bookLocal.id {
                    KFImage(URL(string: "https://books.google.com/books/publisher/content/images/frontcover/\(id)?fife=w500&source=gbs_api"))
                        .placeholder { progress in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.primary.opacity(0.3))
                                .frame(width: 60, height: 90)
                                .overlay{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.primary.opacity(0.4), lineWidth: 2)
                                        
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                    }
                                }
                                .padding(.horizontal)
                        }
                        .fade(duration: 0.5)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(width: 60)
                        .padding(.trailing)
                }
            }
            
            // MARK: - Book info
            VStack(alignment: .leading){
                // Title
                if let title = bookLocal.title{
                    Text(title)
                        .font(.subheadline)
                        .lineLimit(2)
                        .bold()
                }
                
                // Authors
                if let authors = bookLocal.authors{
                    Text(concatAuthors(for: authors))
                        .font(.footnote)
                        .lineLimit(2)
                }
                
                // Average rating with a star
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
            
            // Button to add the book to a list
            Button{
                addItem(with: self.bookLocal)
                sendHapticFeedback.toggle()
                dismiss() // Dismiss the search sheet
            } label: {
                Image(systemName: "plus.circle")
                    .font(.title3)
                    .fontWeight(.regular)
            }
            .sensoryFeedback(.increase, trigger: sendHapticFeedback)
        }
        .onAppear{
            // Get the books that has been deleted to not always recommend the same book
            deletedBooksIDs = (defaults.array(forKey: "deletedIDs") ?? []) as? [String] ?? [""]
        }
    }
    
    // MARK: - Functions
    // Function to add a book in the given list
    private func addItem(with book: BookLocal) {
        
        // Create a variable with the book to save
        let bookToSave = Book(id: book.id, title: book.title, authors: book.authors, publisher: book.publisher, publishedDate: book.publishedDate, descriptionStored: book.descriptionStored, imageLinks: book.imageLinks, categories: book.categories, averageRating: book.averageRating, ratingsCount: book.ratingsCount, pageCount: book.pageCount, language: book.language, previewLink: book.previewLink, infoLink: book.infoLink, list: self.list, addedDate: Date.now)
        
        withAnimation {
            let newItem = bookToSave
            modelContext.insert(newItem) // Insert the item
        }
        
        // MARK: - Recommendation system
        // If the book that is beign added to the finished list
        if self.list == "finishedList" {
            
            // Clean the recommend list
            do {
                try modelContext.delete(
                    model: Book.self,
                    where: #Predicate { item in
                        item.list == "recommendList"
                    }
                )
            } catch {
                print("Error deleting existing recommended books: \(error)")
            }
            
            // Get the authors of the finished books
            let authorsQuery = finishedBooks.flatMap { $0.authors ?? [] }
            
            let lastXAuthorsCount = 5
            // Get only the 5 last authors from the books
            getLastXAuthors(from: authorsQuery, count: lastXAuthorsCount)
            
            // Send the last 5 authors to the api to get the best books from that author
            for author in lastXAuthors {
                let query = "https://www.googleapis.com/books/v1/volumes?q=inauthor:\(author)&orderBy=relevance&maxResults=10"
                Task {
                    guard let bookResponse: BookResponse = await webService.downloadData(fromURL: query) else {
                        print("Could not get a response from the Google Books API")
                        return
                    }
                    
                    handleBookResponse(bookResponse: bookResponse)
                }
            }
        }
    }
    
    // Function to concatenate all the authors with commas and add & to the final author
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
    
    // Function to convert from http to https
    func convertToSecureURL(urlString: String) -> String {
        if urlString.hasPrefix("http://") {
            let secureURLString = urlString.replacingOccurrences(of: "http://", with: "https://")
            return secureURLString
        } else {
            return urlString
        }
    }
    
    // Function to reduce the authors count to the given number
    func getLastXAuthors(from authors: [String], count: Int) {
        guard authors.count >= count else {
            lastXAuthors = authors
            return
        }
        
        let startIndex = authors.count - count
        let endIndex = authors.count
        lastXAuthors = Array(authors[startIndex..<endIndex])
    }
    
    // Function to handle the response of the api of Google Books
    func handleBookResponse(bookResponse: BookResponse) {
        DispatchQueue.main.async {
            // We obtain the desired fields using the response of Google Books
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
                
                // If any of these fields is nil discard the book (this because it can be a book without authors, image links, etc...)
                guard let id = id, let title = title, let authors = authors, let publisher = publisher, let publishedDate = publishedDate, let description = description, let imageLinks = imageLinks else { return }
                
                // If the book is already in the deleted books don't recommend it again
                if deletedBooksIDs.contains(where: {$0 == id }){
                    print("The book was previously deleted")
                    return
                }
                
                // If the book is already in the recommended books list don't recommend it again
                if recommendedBooks.contains(where: { $0.id == id }) {
                    print("The book with ID \(id) is already in the recommendation list.")
                    return
                }
                
                // If the book is already in the reading books list don't recommend it again
                if readingBooks.contains(where: {$0.id == id}) || finishedBooks.contains(where: ({$0.id == id})){
                    print("The book with ID \(id) is already added")
                    return
                }
                
                // Create an instance of a Book
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
                modelContext.insert(newBook) // Insert the book to the model
            }
        }
    }
}

#Preview {
    BookItemInSearch(bookLocal: BookLocal(id: "", title: "", authors: [""], publisher: "", publishedDate: "", descriptionStored: "", imageLinks: nil, categories: [""], averageRating: 0.0, ratingsCount: 10, pageCount: 10, language: "", previewLink: "", infoLink: ""), list: "finishedBook")
}

