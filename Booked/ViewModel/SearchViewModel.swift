//
//  SearchViewModel.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject{
    
    // MARK: - Properties
    @Published var searchTerm = ""
    @Published var books: [BookLocal] = []
    private let searchDelay = 0.5
    
    // A set to hold all the cancellables, i.e., the subscriptions to publishers. This is necessary to keep the subscriptions alive.
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchTerm
        // Removes consecutive duplicates to prevent unnecessary searches.
            .removeDuplicates()
        // Waits for a specified time after the user stops typing before triggering the search.
            .debounce(for: .seconds(searchDelay), scheduler: RunLoop.main)
        // Subscribes to the searchText changes and triggers the music fetch operation.
            .sink { [weak self] searchTerm in
                self?.fetchBooks(with: searchTerm)
            }
        // Stores the subscription in the cancellables set.
            .store(in: &cancellables)
    }
    
    // MARK: - Functions
    // function to search books with the given search term
    func fetchBooks(with searchTerm: String) {
        
        // If the search term is empty clean the books list
        if searchTerm.isEmpty {
            DispatchQueue.main.async {
                self.books = []
            }
            return
        }
        
        // Replace the spaces with a '+' to the format url
        let formattedSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+")
        
        // Define the url with the search term
        let url = "https://www.googleapis.com/books/v1/volumes?q=\(formattedSearchTerm)printType=books&maxResults=25"
        
        Task{
            // Fetch the books with the downloadData function
            guard let bookResponse: BookResponse = await WebService().downloadData(fromURL: url) else {return}
            
            // Pass the response to the handleBookResponse function
            handleBookResponse(bookResponse: bookResponse)
        }
    }
    
    // Function to handle the response of the api of Google Books
    func handleBookResponse(bookResponse: BookResponse){
        DispatchQueue.main.async {
            self.books = bookResponse.items.compactMap({
                // We obtain the desired fields using the response of Google Books
                let id = $0.id
                let title = $0.volumeInfo.title
                let authors = $0.volumeInfo.authors
                let publisher = $0.volumeInfo.publisher
                let publishedDate = $0.volumeInfo.publishedDate
                let description = $0.volumeInfo.description
                let imageLinks = $0.volumeInfo.imageLinks
                let categories = $0.volumeInfo.categories
                let averageRating = $0.volumeInfo.averageRating
                let ratingsCount = $0.volumeInfo.ratingsCount
                let pageCount = $0.volumeInfo.pageCount
                let language = $0.volumeInfo.language
                let previewLink = $0.volumeInfo.previewLink
                let infoLink = $0.volumeInfo.infoLink
                
                // If any of these fields is nil discard the book (this because it can be a book without authors, image links, etc...)
                guard id != nil, title != nil, authors != nil, publisher != nil, publishedDate != nil, description != nil, imageLinks != nil else { return nil }
                
                // Return a book usign the BookLocal defined model
                return BookLocal(
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
                    infoLink: infoLink
                )
            })
        }
    }

}
