//
//  DiscoverView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct DiscoverView: View {
    
    var body: some View {
        VStack{
            SingleBookCard(bookInfo: Book(id: Optional("qr3NEAAAQBAJ"), title: Optional("Alas de sangre (Empíreo 1) (Edición española)"), authors: ["Rebecca Yarros"], publisher: Optional("Editorial Planeta"), publishedDate: Optional("2023-11-15"), descriptionStored: Optional("Vuela... o muere. El nuevo fenómeno de fantasía juvenil del que todo el mundo habla. «¡La novela de fantasía más brutalmente adictiva que he leído en una década!» Tracy Wolff, autora de la Serie Crave Violet Sorrengail creía que se uniría al Cuadrante de los Escribas para vivir una vida tranquila, sin embargo, por órdenes de su madre, debe unirse a los miles de candidatos que, en el Colegio de Guerra de Basgiath, luchan por formar parte de la élite de Navarre: el Cuadrante de los Jinetes de dragones. Cuando eres más pequeña y frágil que los demás tu vida corre peligro, porque los dragones no se vinculan con humanos débiles. Además, con más jinetes que dragones disponibles, muchos la matarían con tal de mejorar sus probabilidades de éxito; y hay otros, como el despiadado Xaden Riorson, el líder de ala más poderoso del Cuadrante de Jinetes, que la asesinarían simplemente por ser la hija de la comandante general. Para sobrevivir, necesitará aprovechar al máximo todo su ingenio. Mientras la guerra se torna más letal Violet sospecha que los líderes de Navarre esconden un terrible secreto..."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=qr3NEAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Fiction"]), averageRating: nil, ratingsCount: nil, pageCount: Optional(655), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=qr3NEAAAQBAJ&printsec=frontcover&dq=alas+de+sangre&hl=&cd=1&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=qr3NEAAAQBAJ&source=gbs_api"), list: "", addedDate: Date.now))
                
            
            ActionButton(icon: "bookmark", label: "Add to reading list"){
                print("button pressed")
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    DiscoverView()
}
