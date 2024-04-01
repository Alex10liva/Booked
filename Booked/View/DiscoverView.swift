//
//  DiscoverView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct DiscoverView: View {
    
    @State var selectedBook: Book?
    
    let books: [Book] = [
        Book(id: Optional("qr3NEAAAQBAJ"), title: Optional("Alas de sangre (Empíreo 1) (Edición española)"), authors: ["Rebecca Yarros"], publisher: Optional("Editorial Planeta"), publishedDate: Optional("2023-11-15"), descriptionStored: Optional("Vuela... o muere. El nuevo fenómeno de fantasía juvenil del que todo el mundo habla. «¡La novela de fantasía más brutalmente adictiva que he leído en una década!» Tracy Wolff, autora de la Serie Crave Violet Sorrengail creía que se uniría al Cuadrante de los Escribas para vivir una vida tranquila, sin embargo, por órdenes de su madre, debe unirse a los miles de candidatos que, en el Colegio de Guerra de Basgiath, luchan por formar parte de la élite de Navarre: el Cuadrante de los Jinetes de dragones. Cuando eres más pequeña y frágil que los demás tu vida corre peligro, porque los dragones no se vinculan con humanos débiles. Además, con más jinetes que dragones disponibles, muchos la matarían con tal de mejorar sus probabilidades de éxito; y hay otros, como el despiadado Xaden Riorson, el líder de ala más poderoso del Cuadrante de Jinetes, que la asesinarían simplemente por ser la hija de la comandante general. Para sobrevivir, necesitará aprovechar al máximo todo su ingenio. Mientras la guerra se torna más letal Violet sospecha que los líderes de Navarre esconden un terrible secreto..."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Fiction"]), averageRating: nil, ratingsCount: nil, pageCount: Optional(655), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=qr3NEAAAQBAJ&printsec=frontcover&dq=alas+de+sangre&hl=&cd=1&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=qr3NEAAAQBAJ&source=gbs_api"), list: "", addedDate: Date.now),
        Book(id: Optional("qr3NEAAAQBAJ"), title: Optional("Alas de sangre (Empíreo 1) (Edición española)"), authors: ["Rebecca Yarros"], publisher: Optional("Editorial Planeta"), publishedDate: Optional("2023-11-15"), descriptionStored: Optional("Vuela... o muere. El nuevo fenómeno de fantasía juvenil del que todo el mundo habla. «¡La novela de fantasía más brutalmente adictiva que he leído en una década!» Tracy Wolff, autora de la Serie Crave Violet Sorrengail creía que se uniría al Cuadrante de los Escribas para vivir una vida tranquila, sin embargo, por órdenes de su madre, debe unirse a los miles de candidatos que, en el Colegio de Guerra de Basgiath, luchan por formar parte de la élite de Navarre: el Cuadrante de los Jinetes de dragones. Cuando eres más pequeña y frágil que los demás tu vida corre peligro, porque los dragones no se vinculan con humanos débiles. Además, con más jinetes que dragones disponibles, muchos la matarían con tal de mejorar sus probabilidades de éxito; y hay otros, como el despiadado Xaden Riorson, el líder de ala más poderoso del Cuadrante de Jinetes, que la asesinarían simplemente por ser la hija de la comandante general. Para sobrevivir, necesitará aprovechar al máximo todo su ingenio. Mientras la guerra se torna más letal Violet sospecha que los líderes de Navarre esconden un terrible secreto..."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Fiction"]), averageRating: nil, ratingsCount: nil, pageCount: Optional(655), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=qr3NEAAAQBAJ&printsec=frontcover&dq=alas+de+sangre&hl=&cd=1&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=qr3NEAAAQBAJ&source=gbs_api"), list: "", addedDate: Date.now),
        Book(id: Optional("qr3NEAAAQBAJ"), title: Optional("Alas de sangre (Empíreo 1) (Edición española)"), authors: ["Rebecca Yarros"], publisher: Optional("Editorial Planeta"), publishedDate: Optional("2023-11-15"), descriptionStored: Optional("Vuela... o muere. El nuevo fenómeno de fantasía juvenil del que todo el mundo habla. «¡La novela de fantasía más brutalmente adictiva que he leído en una década!» Tracy Wolff, autora de la Serie Crave Violet Sorrengail creía que se uniría al Cuadrante de los Escribas para vivir una vida tranquila, sin embargo, por órdenes de su madre, debe unirse a los miles de candidatos que, en el Colegio de Guerra de Basgiath, luchan por formar parte de la élite de Navarre: el Cuadrante de los Jinetes de dragones. Cuando eres más pequeña y frágil que los demás tu vida corre peligro, porque los dragones no se vinculan con humanos débiles. Además, con más jinetes que dragones disponibles, muchos la matarían con tal de mejorar sus probabilidades de éxito; y hay otros, como el despiadado Xaden Riorson, el líder de ala más poderoso del Cuadrante de Jinetes, que la asesinarían simplemente por ser la hija de la comandante general. Para sobrevivir, necesitará aprovechar al máximo todo su ingenio. Mientras la guerra se torna más letal Violet sospecha que los líderes de Navarre esconden un terrible secreto..."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Fiction"]), averageRating: nil, ratingsCount: nil, pageCount: Optional(655), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=qr3NEAAAQBAJ&printsec=frontcover&dq=alas+de+sangre&hl=&cd=1&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=qr3NEAAAQBAJ&source=gbs_api"), list: "", addedDate: Date.now),
        Book(id: Optional("qr3NEAAAQBAJ"), title: Optional("Alas de sangre (Empíreo 1) (Edición española)"), authors: ["Rebecca Yarros"], publisher: Optional("Editorial Planeta"), publishedDate: Optional("2023-11-15"), descriptionStored: Optional("Vuela... o muere. El nuevo fenómeno de fantasía juvenil del que todo el mundo habla. «¡La novela de fantasía más brutalmente adictiva que he leído en una década!» Tracy Wolff, autora de la Serie Crave Violet Sorrengail creía que se uniría al Cuadrante de los Escribas para vivir una vida tranquila, sin embargo, por órdenes de su madre, debe unirse a los miles de candidatos que, en el Colegio de Guerra de Basgiath, luchan por formar parte de la élite de Navarre: el Cuadrante de los Jinetes de dragones. Cuando eres más pequeña y frágil que los demás tu vida corre peligro, porque los dragones no se vinculan con humanos débiles. Además, con más jinetes que dragones disponibles, muchos la matarían con tal de mejorar sus probabilidades de éxito; y hay otros, como el despiadado Xaden Riorson, el líder de ala más poderoso del Cuadrante de Jinetes, que la asesinarían simplemente por ser la hija de la comandante general. Para sobrevivir, necesitará aprovechar al máximo todo su ingenio. Mientras la guerra se torna más letal Violet sospecha que los líderes de Navarre esconden un terrible secreto..."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Fiction"]), averageRating: nil, ratingsCount: nil, pageCount: Optional(655), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=qr3NEAAAQBAJ&printsec=frontcover&dq=alas+de+sangre&hl=&cd=1&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=qr3NEAAAQBAJ&source=gbs_api"), list: "", addedDate: Date.now),
        Book(id: Optional("qr3NEAAAQBAJ"), title: Optional("Alas de sangre (Empíreo 1) (Edición española)"), authors: ["Rebecca Yarros"], publisher: Optional("Editorial Planeta"), publishedDate: Optional("2023-11-15"), descriptionStored: Optional("Vuela... o muere. El nuevo fenómeno de fantasía juvenil del que todo el mundo habla. «¡La novela de fantasía más brutalmente adictiva que he leído en una década!» Tracy Wolff, autora de la Serie Crave Violet Sorrengail creía que se uniría al Cuadrante de los Escribas para vivir una vida tranquila, sin embargo, por órdenes de su madre, debe unirse a los miles de candidatos que, en el Colegio de Guerra de Basgiath, luchan por formar parte de la élite de Navarre: el Cuadrante de los Jinetes de dragones. Cuando eres más pequeña y frágil que los demás tu vida corre peligro, porque los dragones no se vinculan con humanos débiles. Además, con más jinetes que dragones disponibles, muchos la matarían con tal de mejorar sus probabilidades de éxito; y hay otros, como el despiadado Xaden Riorson, el líder de ala más poderoso del Cuadrante de Jinetes, que la asesinarían simplemente por ser la hija de la comandante general. Para sobrevivir, necesitará aprovechar al máximo todo su ingenio. Mientras la guerra se torna más letal Violet sospecha que los líderes de Navarre esconden un terrible secreto..."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Fiction"]), averageRating: nil, ratingsCount: nil, pageCount: Optional(655), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=qr3NEAAAQBAJ&printsec=frontcover&dq=alas+de+sangre&hl=&cd=1&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=qr3NEAAAQBAJ&source=gbs_api"), list: "", addedDate: Date.now)
    ]
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(books, id: \.self) { book in
                        SingleBookCard(bookInfo: book)
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.6)
                            }
                    }
                }
                .scrollTargetLayout()
                .sensoryFeedback(.increase, trigger: selectedBook)
            }
            .scrollClipDisabled()
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $selectedBook)
            .onAppear{
                selectedBook = books[0]
            }
            
            HStack{
                ForEach(books.indices, id: \.self){ index in
                    
                    if let selectedBook, let selectedBookIndex = books.firstIndex(of: selectedBook){
                        Circle()
                            .fill(selectedBookIndex == index ? Color.primary : Color.secondary.opacity(0.6))
                            .frame(height: 5)
                    }
                }
            }
            .padding(.bottom, 20)
            
            ZStack{
                Capsule()
                    .fill(.thinMaterial)
                    .frame(height: 60)
                    
                
                HStack{
                    Button {
                        guard let selectedBook, let index = books.firstIndex(of: selectedBook), index > 0 else { return }
                        
                        withAnimation{
                            self.selectedBook = books[index - 1]
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .bold()
                            .foregroundStyle(.primary.opacity(selectedBook == books.first ? 0.3 : 1.0))
                    }
                    .disabled(selectedBook == books.first)
                    .padding(5)
                    
                    Spacer()
                    
                    ActionButton(icon: "bookmark", label: "Add to reading list"){
                        print("button pressed")
                    }
                    
                    Spacer()
                    
                    Button {
                        guard let selectedBook, let index = books.firstIndex(of: selectedBook), index < books.count - 1 else { return }
                        
                        withAnimation{
                            self.selectedBook = books[index + 1]
                        }
                    } label: {
                        Image(systemName: "arrow.right")
                            .bold()
                            .foregroundStyle(.primary.opacity(selectedBook == books.last ? 0.3 : 1.0))
                    }
                    .disabled(selectedBook == books.last)
                    .padding(5)
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal)
            
        }
        .padding(.vertical)
//        .safeAreaPadding(.horizontal, 20)
    }
}

#Preview {
    DiscoverView()
}
