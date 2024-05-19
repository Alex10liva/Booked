//
//  SingleBookCard.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import Kingfisher

struct SingleBookCard: View {
    
    // MARK: - Properties
    var bookInfo: Book
    @State var isBookDescriptionDisplayed: Bool = false
    @Binding var tabSelection: Int
    
    // MARK: - Body
    var body: some View {
        VStack{
            
            Spacer()
            
            // MARK: - Book cover art
            // If the book has extra large image display it
            if let extraLarge = bookInfo.imageLinks?.extraLarge{
                KFImage(URL(string: extraLarge)) /// king fisher (library for downloading and caching images from the web)
                    .onFailure { error in
                        print("Error loading image: \(error.localizedDescription)")
                    }
                    .placeholder { _ in
                        // While the image is loading show a rectangle with a progress view
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.primary.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .aspectRatio(2/3, contentMode: .fit)
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary.opacity(0.3), lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.13), radius: 25, x: 0.0, y: 8.0)
            } else {
                // Use the id of the book to get the front cover with a width of 1000
                if let id = bookInfo.id {
                    KFImage(URL(string: "https://books.google.com/books/publisher/content/images/frontcover/\(id)?fife=w1000&source=gbs_api"))
                        .onFailure { error in
                            print("Error loading image: \(error.localizedDescription)")
                        }
                        .placeholder { _ in
                            // While the image is loading show a rectangle with a progress view
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.primary.opacity(0.3))
                                .frame(maxWidth: .infinity)
                                .aspectRatio(2/3, contentMode: .fit)
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary.opacity(0.3), lineWidth: 2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.13), radius: 25, x: 0.0, y: 8.0)
                }
            }
            
            // MARK: - Book info
            VStack(spacing: 5){
                // Title
                if let title = bookInfo.title {
                    Text(title)
                        .font(.title)
                        .bold()
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                
                // Authors
                if let authors = bookInfo.authors {
                    Text(concatAuthors(for: authors))
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
        }
        .padding()
        .onTapGesture {
            withAnimation{
                isBookDescriptionDisplayed.toggle() // Open the book description in full screen
            }
        }
        .fullScreenCover(isPresented: $isBookDescriptionDisplayed){
            BookDescriptionView(book: bookInfo, showOptions: false, selectedTabInLibrary: .constant(.readingList), tabSelection: $tabSelection, showActionButton: true)
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
}

#Preview {
    SingleBookCard(bookInfo: Book(id: Optional("2zgRDXFWkm8C"), title: Optional("Harry Potter y la piedra filosofal"), authors: Optional(["J.K. Rowling"]), publisher: Optional("Pottermore Publishing"), publishedDate: Optional("2015-12-08"), descriptionStored: Optional("Con las manos temblorosas, Harry le dio la vuelta al sobre y vio un sello de lacre púrpura con un escudo de armas: un león, un águila, un tejón y una serpiente, que rodeaban una gran letra H. Harry Potter nunca había oído nada sobre Hogwarts cuando las cartas comienzan a caer en el felpudo del número cuatro de Privet Drive. Escritas en tinta verde en un pergamino amarillento con un sello morado, sus horribles tíos las han confiscado velozmente. En su undécimo cumpleaños, un hombre gigante de ojos negros llamado Rubeus Hagrid aparece con una noticia extraordinaria: Harry Potter es un mago y tiene una plaza en el Colegio Hogwarts de Magia y Hechicería. ¡Una aventura increíble está a punto de empezar! Tema musical compuesto por James Hannigan."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Juvenile Fiction"]), averageRating: Optional(4.0), ratingsCount: Optional(124), pageCount: Optional(320), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=2zgRDXFWkm8C&printsec=frontcover&dq=harry&hl=&cd=2&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=2zgRDXFWkm8C&source=gbs_api"), list: "", addedDate: Date.now), tabSelection: .constant(2))
}


