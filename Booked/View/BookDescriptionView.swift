//
//  BookDescriptionView.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 28/03/24.
//

import SwiftUI
import SwiftData
import Kingfisher

struct BookDescriptionView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Book]
    
    @Environment(\.dismiss) var dismiss
    
    @State var book: Book
    @State private var hideStatusBar: Bool = false
    @Binding var selectedTab: Tab?
    @State var showOptions: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView{
                    
                    Spacer(minLength: 30)
                    
                    LazyVStack{
                        
                        VStack{
                            if let extraLarge = book.imageLinks?.extraLarge{
                                KFImage(URL(string: extraLarge))
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
//                                    .padding(.horizontal)
                                    .shadow(color: .black.opacity(0.13), radius: 25, x: 0.0, y: 8.0)
                                
                                
                            } else {
                                if let id = book.id {
                                    KFImage(URL(string: "https://books.google.com/books/publisher/content/images/frontcover/\(id)?fife=w1200&source=gbs_api"))
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
//                                        .padding(.horizontal)
                                        .shadow(color: .black.opacity(0.13), radius: 25, x: 0.0, y: 8.0)
                                }
                            }
                        }
                        .padding()
                        
                        VStack(spacing: 5){
                            
                            if let title = book.title {
                                Text(title)
                                    .font(.title)
                                    .bold()
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                            }
                            
                            if let authors = book.authors {
                                Text(concatAuthors(for: authors))
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        
                        Spacer(minLength: 30)
                        
                        if let descriptionStored = book.descriptionStored {
                            Text(descriptionStored)
                                .lineSpacing(4)
                                .kerning(0.5)
//                                .minimumScaleFactor(0.5)
                        }
                    }
                    .padding()
                    
                    Spacer(minLength: 60)
                }
                
                
                VStack{
                    
                    HStack{
                        
                        Button{
                            hideStatusBar.toggle()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.primary, .clear)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        if showOptions {
                            Menu {
                                Button {
                                    dismiss()
                                        
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                        withAnimation{
                                            selectedTab = selectedTab == .readingList ? .finishedBooks : .readingList
                                            
                                            if let bookIndex = items.firstIndex(where: {$0.id == book.id}){
                                                items[bookIndex].addedDate = Date.now
                                                items[bookIndex].list = items[bookIndex].list == "finishedList" ? "readingList" : "finishedList"
                                            }
                                        }
                                    }
                                } label: {
                                    Label("Move to \(selectedTab == .readingList ? "finished books" : "reading list")", systemImage: selectedTab == .readingList ? "arrow.right" : "arrow.left")
                                }
                                
                                Button(role: .destructive) {
                                    withAnimation{
                                        dismiss()
                                        if let bookIndex = items.firstIndex(where: {$0.id == book.id}){
                                            modelContext.delete(items[bookIndex])
                                        }
                                    }
                                } label: {
                                    Label("Remove book", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle.fill")
                                    .font(.title)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.primary, .clear)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing)
                        }
                    }
                    
                    
                    Spacer()
                    
                    ActionButton(icon: "bookmark", label: "Add to reading list"){
                        print("Action button")
                    }
                }
            }
            .onAppear{
                withAnimation {
                    hideStatusBar.toggle()
                }
            }
        }
        .statusBar(hidden: hideStatusBar)
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
    BookDescriptionView(book: Book(id: Optional("2zgRDXFWkm8C"), title: Optional("Harry Potter y la piedra filosofal"), authors: Optional(["J.K. Rowling"]), publisher: Optional("Pottermore Publishing"), publishedDate: Optional("2015-12-08"), descriptionStored: Optional("Con las manos temblorosas, Harry le dio la vuelta al sobre y vio un sello de lacre púrpura con un escudo de armas: un león, un águila, un tejón y una serpiente, que rodeaban una gran letra H. Harry Potter nunca había oído nada sobre Hogwarts cuando las cartas comienzan a caer en el felpudo del número cuatro de Privet Drive. Escritas en tinta verde en un pergamino amarillento con un sello morado, sus horribles tíos las han confiscado velozmente. En su undécimo cumpleaños, un hombre gigante de ojos negros llamado Rubeus Hagrid aparece con una noticia extraordinaria: Harry Potter es un mago y tiene una plaza en el Colegio Hogwarts de Magia y Hechicería. ¡Una aventura increíble está a punto de empezar! Tema musical compuesto por James Hannigan."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Juvenile Fiction"]), averageRating: Optional(4.0), ratingsCount: Optional(124), pageCount: Optional(320), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=2zgRDXFWkm8C&printsec=frontcover&dq=harry&hl=&cd=2&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=2zgRDXFWkm8C&source=gbs_api"), list: "", addedDate: Date.now), selectedTab: .constant(.finishedBooks))
}
