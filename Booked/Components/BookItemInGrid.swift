//
//  BookItemInGrid.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import Kingfisher

struct BookItemInGrid: View {
    
    @State var book: Book
    @State var imageLoaded: Bool = false
    
    var body: some View {
        VStack (alignment: .leading){
            if let id = book.id{
                
                KFImage(URL(string: "https://books.google.com/books/publisher/content/images/frontcover/\(id)?fife=w1200&source=gbs_api"))
                    .onSuccess{ result in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)){
                            imageLoaded = true
                        }
                    }
                    .onFailure { error in
                        print("Error loading image: \(error.localizedDescription)")
                    }
                    .placeholder { progress in
                        Rectangle()
                            .fill(.primary.opacity(0.5))
                            .frame(width: 167, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay{
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                        
                    }
                    .fade(duration: 0.5)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 167)
                    .frame(maxHeight: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.primary.opacity(0.3), lineWidth: 0.5)
                    )
            }
            
            if let title = book.title{
                Text(title)
                    .font(.subheadline)
                    .lineLimit(2)
            }
            
            if let authors = book.authors{
                Text(concatAuthors(for: authors))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
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
        // Verificar si la URL comienza con "http://"
        if urlString.hasPrefix("http://") {
            // Reemplazar "http://" con "https://"
            let secureURLString = urlString.replacingOccurrences(of: "http://", with: "https://")
            return secureURLString
        } else {
            // Si la URL ya es segura (https://), devolverla sin cambios
            return urlString
        }
    }
}

#Preview {
    BookItemInGrid(book: Book(id: "", title: "", authors: [""], publisher: "", publishedDate: "", descriptionStored: "", imageLinks: nil, categories: [""], averageRating: 0.0, ratingsCount: 10, pageCount: 1, language: "", previewLink: "", infoLink: "", list: "readingList", addedDate: Date.now))
}
