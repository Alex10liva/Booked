//
//  SingleBookCard.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI
import Kingfisher

struct SingleBookCard: View {
    
    let bookInfo: Book
    @State var imageLoaded: Bool = false
    @State var isBookDescriptionDisplayed: Bool = false
    
    @State var bookCover: Image?
    
    var body: some View {
        VStack{
            
            if let extraLarge = bookInfo.imageLinks?.extraLarge{
                KFImage(URL(string: extraLarge))
                    .onSuccess{ result in
                        imageLoaded = true
                        self.bookCover = Image(uiImage: result.image)
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary.opacity(0.3), lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.13), radius: 25, x: 0.0, y: 8.0)
                
                
            } else {
                if let id = bookInfo.id {
                    KFImage(URL(string: "https://books.google.com/books/publisher/content/images/frontcover/\(id)?fife=w1200&source=gbs_api"))
                        .onSuccess{ result in
                            imageLoaded = true
                            self.bookCover = Image(uiImage: result.image)
                        }
                        .placeholder { progress in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.primary.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .frame(width: 60, height: 90)
                                .overlay{
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.primary.opacity(0.3), lineWidth: 2)
                                        
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
            
            VStack(spacing: 5){
                
                if let title = bookInfo.title {
                    Text(title)
                        .font(.title)
                        .bold()
//                        .padding(.horizontal)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                
                if let authors = bookInfo.authors {
                    let _ = print("authors:  \(authors.isEmpty)")
                    Text(concatAuthors(for: authors))
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding()
        .onTapGesture {
            withAnimation{
                isBookDescriptionDisplayed.toggle()
            }
        }
        .fullScreenCover(isPresented: $isBookDescriptionDisplayed){
            BookDescriptionView(book: bookInfo)
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
}

#Preview {
    SingleBookCard(bookInfo: Book(id: Optional("2zgRDXFWkm8C"), title: Optional("Harry Potter y la piedra filosofal"), authors: Optional(["J.K. Rowling"]), publisher: Optional("Pottermore Publishing"), publishedDate: Optional("2015-12-08"), descriptionStored: Optional("Con las manos temblorosas, Harry le dio la vuelta al sobre y vio un sello de lacre púrpura con un escudo de armas: un león, un águila, un tejón y una serpiente, que rodeaban una gran letra H. Harry Potter nunca había oído nada sobre Hogwarts cuando las cartas comienzan a caer en el felpudo del número cuatro de Privet Drive. Escritas en tinta verde en un pergamino amarillento con un sello morado, sus horribles tíos las han confiscado velozmente. En su undécimo cumpleaños, un hombre gigante de ojos negros llamado Rubeus Hagrid aparece con una noticia extraordinaria: Harry Potter es un mago y tiene una plaza en el Colegio Hogwarts de Magia y Hechicería. ¡Una aventura increíble está a punto de empezar! Tema musical compuesto por James Hannigan."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Juvenile Fiction"]), averageRating: Optional(4.0), ratingsCount: Optional(124), pageCount: Optional(320), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=2zgRDXFWkm8C&printsec=frontcover&dq=harry&hl=&cd=2&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=2zgRDXFWkm8C&source=gbs_api"), list: "", addedDate: Date.now))
}


