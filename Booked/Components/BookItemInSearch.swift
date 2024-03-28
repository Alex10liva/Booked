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
    @Query private var items: [Book]
    
    @Environment(\.dismiss) var dismiss
    
    @State var bookLocal: BookLocal
    @State var imageLoaded: Bool = false
    @State var imageURLs: [String] = []
    @State var list: String
    @State var sendHapticFeedback: Bool = false
    
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
            // Agregar las URLs de las imágenes a la lista, comenzando por la más pequeña
            if let thumbnail = bookLocal.imageLinks?.thumbnail {
                self.imageURLs.append(convertToSecureURL(urlString: thumbnail))
            }
            if let smallThumbnail = bookLocal.imageLinks?.smallThumbnail {
                self.imageURLs.append(convertToSecureURL(urlString: smallThumbnail))
            }
            if let small = bookLocal.imageLinks?.small {
                self.imageURLs.append(convertToSecureURL(urlString: small))
            }
            if let medium = bookLocal.imageLinks?.medium {
                self.imageURLs.append(convertToSecureURL(urlString: medium))
            }
            if let large = bookLocal.imageLinks?.large {
                self.imageURLs.append(convertToSecureURL(urlString: large))
            }
            if let extraLarge = bookLocal.imageLinks?.extraLarge {
                self.imageURLs.append(convertToSecureURL(urlString: extraLarge))
            }
        }
    }
    
    private func addItem(with book: BookLocal) {
        
        let bookToSave = Book(id: book.id, title: book.title, authors: book.authors, publisher: book.publisher, publishedDate: book.publishedDate, descriptionStored: book.descriptionStored, imageLinks: book.imageLinks, categories: book.categories, averageRating: book.averageRating, ratingsCount: book.ratingsCount, pageCount: book.pageCount, language: book.language, previewLink: book.previewLink, infoLink: book.infoLink, list: self.list, addedDate: Date.now)
        
        withAnimation {
            let newItem = bookToSave
            modelContext.insert(newItem)
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
    BookItemInSearch(bookLocal: BookLocal(id: "", title: "", authors: [""], publisher: "", publishedDate: "", descriptionStored: "", imageLinks: nil, categories: [""], averageRating: 0.0, ratingsCount: 10, pageCount: 10, language: "", previewLink: "", infoLink: ""), list: "finishedBook")
}
