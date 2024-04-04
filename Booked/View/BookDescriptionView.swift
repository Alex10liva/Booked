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
    @Query private var books: [Book]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State var book: Book
    @State private var hideStatusBar: Bool = false
    @Binding var selectedTab: Tab?
    @Binding var tabSelection: Int
    @State var showOptions: Bool = false
    @State private var isConfirming = false
    @State private var dialogDetail: BookDetails?
    
    @State private var scrollPosition: CGPoint = .zero
    @State private var isActionButtonVisible = false
    @State private var showActionButtonAtStart = false
    @State private var buttonOffset = CGSize(width: 0, height: UIScreen.main.bounds.height)
    @State var showActionButton: Bool
    let defaults = UserDefaults.standard
    @State var deletedBooksIDs: [String] = []
    
    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView{
                    
                    Spacer(minLength: 30)
                    
                    VStack{
                        
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
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                            .onAppear{
                                if geometry.size.height < 600 {
                                    self.isActionButtonVisible = true
                                    self.showActionButtonAtStart = true
                                }
                            }
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.scrollPosition = value
                        
                        if defaults.bool(forKey: "buttonAppeared") == false {
                            self.isActionButtonVisible = value.y < -50
                        }
                    }
                    
                    Spacer(minLength: 60)
                }
                .coordinateSpace(name: "scroll")
                
                VStack{
                    
                    HStack{
                        
                        Button{
                            hideStatusBar.toggle()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.ultraThickMaterial, colorScheme == .light ? Color(hex: "#474747") : Color(hex: "#D8D8D8"))
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
                                            
                                            if let bookIndex = books.firstIndex(where: {$0.id == book.id}){
                                                books[bookIndex].addedDate = Date.now
                                                books[bookIndex].list = books[bookIndex].list == "finishedList" ? "readingList" : "finishedList"
                                            }
                                        }
                                    }
                                } label: {
                                    Label("Move to \(selectedTab == .readingList ? "finished books" : "reading list")", systemImage: selectedTab == .readingList ? "arrow.right" : "arrow.left")
                                }
                                
                                Button(role: .destructive) {
                                    if let id = book.id, let title = book.title {
                                        dialogDetail = BookDetails(id: id, title: title)
                                    }
                                    isConfirming = true
                                    
                                } label: {
                                    Label("Remove book", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle.fill")
                                    .font(.title)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.ultraThickMaterial, colorScheme == .light ? Color(hex: "#474747") : Color(hex: "#D8D8D8"))
                                    .clipShape(Circle())
                            }
                            .padding(.trailing)
                            .confirmationDialog(
                                "Are you sure you want to delete this book?",
                                isPresented: $isConfirming, titleVisibility: .visible, presenting: dialogDetail
                            ) { detail in
                                Button(role: .destructive) {
                                    dismiss()
                                    
                                    if let bookId = book.id {
                                        deletedBooksIDs.append(bookId)
                                        defaults.set(deletedBooksIDs, forKey: "deletedIDs")
                                    }
                                    
                                    if let bookIndex = books.firstIndex(where: {$0.id == book.id}){
                                        withAnimation{
                                            modelContext.delete(books[bookIndex])
                                        }
                                    }
                                } label: {
                                    Text("Delete \(detail.title)")
                                }
                                
                                Button("Cancel", role: .cancel) {
                                    dialogDetail = nil
                                }
                            }
                        }
                    }
                    
                    
                    Spacer()
                    
                    if isActionButtonVisible && showActionButton{
                        Menu {
                            
                            Button{
                                addItem(with: book, listToSave: "finishedList")
                            } label: {
                                Label("Finished books", systemImage: "checkmark")
                            }
                            
                            Button{
                                addItem(with: book, listToSave: "readingList")
                            } label: {
                                Label("Reading list", systemImage: "bookmark")
                            }
                            
                        } label: {
                            ActionButton(icon: "plus", label: "Add to my library", isInBookDescription: true)
                        }
                        .offset(y: buttonOffset.height)
                        .onAppear{
                            defaults.set(true, forKey: "buttonAppeared")
                            
                            if showActionButtonAtStart {
                                buttonOffset = CGSize(width: 0, height: 0)
                            } else {
                                withAnimation(.bouncy(duration: 0.5).delay(0.2)) {
                                    buttonOffset = CGSize(width: 0, height: 0)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear{
                withAnimation {
                    hideStatusBar.toggle()
                }
            }
        }
        .onAppear{
            defaults.set(false, forKey: "buttonAppeared")
            deletedBooksIDs = (defaults.array(forKey: "deletedIDs") ?? []) as? [String] ?? [""]
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
    
    private func addItem(with book: Book, listToSave: String) {
        withAnimation{
            
            dismiss()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let bookIndex = books.firstIndex(where: {$0.id == book.id}){
                    books[bookIndex].addedDate = Date.now
                    books[bookIndex].list = listToSave
                }
                self.tabSelection = 2
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.selectedTab = listToSave == "finishedList" ? .finishedBooks : .readingList
            }
        }
    }
}

#Preview {
    BookDescriptionView(book: Book(id: Optional("2zgRDXFWkm8C"), title: Optional("Harry Potter y la piedra filosofal"), authors: Optional(["J.K. Rowling"]), publisher: Optional("Pottermore Publishing"), publishedDate: Optional("2015-12-08"), descriptionStored: Optional("Con las manos temblorosas, Harry le dio la vuelta al sobre y vio un sello de lacre púrpura con un escudo de armas: un león, un águila, un tejón y una serpiente, que rodeaban una gran letra H. Harry Potter nunca había oído nada sobre Hogwarts cuando las cartas comienzan a caer en el felpudo del número cuatro de Privet Drive. Escritas en tinta verde en un pergamino amarillento con un sello morado, sus horribles tíos las han confiscado velozmente. En su undécimo cumpleaños, un hombre gigante de ojos negros llamado Rubeus Hagrid aparece con una noticia extraordinaria: Harry Potter es un mago y tiene una plaza en el Colegio Hogwarts de Magia y Hechicería. ¡Una aventura increíble está a punto de empezar! Tema musical compuesto por James Hannigan."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Juvenile Fiction"]), averageRating: Optional(4.0), ratingsCount: Optional(124), pageCount: Optional(320), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=2zgRDXFWkm8C&printsec=frontcover&dq=harry&hl=&cd=2&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=2zgRDXFWkm8C&source=gbs_api"), list: "", addedDate: Date.now), selectedTab: .constant(.finishedBooks), tabSelection: .constant(2), showActionButton: true)
}
