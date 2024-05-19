//
//  BookItemInGrid.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import Kingfisher

struct BookItemInGrid: View {
    
    // MARK: - Properties
    @State var book: Book
    
    // MARK: - Body
    var body: some View {
        VStack (alignment: .leading){
            // If the book has large image display it
            if let extraLarge = book.imageLinks?.large{
                KFImage(URL(string: extraLarge)) /// king fisher (library for downloading and caching images from the web)
                    .onFailure { error in
                        print("Error loading image: \(error.localizedDescription)")
                    }
                    .placeholder { progress in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.primary.opacity(0.3))
                            .frame(width: 170, height: 255)
                            .overlay{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.primary.opacity(0.4), lineWidth: 2)
                                    
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                            }
                    }
                    .fade(duration: 0.5)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170)
                    .frame(maxHeight: 255)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.primary.opacity(0.4), lineWidth: 0.5)
                    )
            } else {
                if let id = book.id{
                    // Use the id of the book to get the front cover with a width of 500
                    KFImage(URL(string: "https://books.google.com/books/publisher/content/images/frontcover/\(id)?fife=w500&source=gbs_api"))
                        .onFailure { error in
                            print("Error loading image: \(error.localizedDescription)")
                        }
                        .placeholder { progress in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.primary.opacity(0.3))
                                .frame(width: 170, height: 255)
                                .overlay{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.primary.opacity(0.4), lineWidth: 2)
                                        
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                    }
                                }
                        }
                        .fade(duration: 0.5)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 170)
                        .frame(maxHeight: 255)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.primary.opacity(0.4), lineWidth: 0.5)
                        )
                }
            }
            
            // MARK: - Book info
            // Title
            if let title = book.title{
                Text(title)
                    .font(.subheadline)
                    .lineLimit(2)
            }
            
            // Authors
            if let authors = book.authors{
                Text(concatAuthors(for: authors))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
    
    // MARK: - Functions
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
}

#Preview {
    BookItemInGrid(book: Book(id: "", title: "", authors: [""], publisher: "", publishedDate: "", descriptionStored: "", imageLinks: nil, categories: [""], averageRating: 0.0, ratingsCount: 10, pageCount: 1, language: "", previewLink: "", infoLink: "", list: "readingList", addedDate: Date.now))
}
