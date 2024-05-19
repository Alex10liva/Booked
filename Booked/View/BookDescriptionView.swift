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
    
    // MARK: - Environment properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Swift data queries
    @Query private var books: [Book]
    
    // MARK: - Properties
    @State var book: Book
    @State var showOptions: Bool = false
    @State private var hideStatusBar: Bool = false
    @State private var isConfirming = false
    @State private var dialogDetail: BookDetails?
    @Binding var selectedTabInLibrary: Tab?
    @Binding var tabSelection: Int
    
    @State private var scrollPosition: CGPoint = .zero
    @State private var isActionButtonVisible = false
    @State private var showActionButtonAtStart = false
    @State private var buttonOffset = CGSize(width: 0, height: UIScreen.main.bounds.height)
    @State var showActionButton: Bool
    @State var deletedBooksIDs: [String] = []
    let defaults = UserDefaults.standard
    
    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView{
                    
                    // Spacer to let space for the close and options buttons
                    Spacer(minLength: 30)
                    
                    VStack{
                        VStack{
                            // MARK: - Book cover art
                            // If the book has extra large image display it
                            if let extraLarge = book.imageLinks?.extraLarge{
                                KFImage(URL(string: extraLarge)) /// king fisher (library for downloading and caching images from the web)
                                    .placeholder { progress in
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
                                    .shadow(color: .black.opacity(0.13), radius: 25, x: 0.0, y: 8.0)
                                
                                
                            } else {
                                if let id = book.id {
                                    // Use the id of the book to get the front cover with a width of 1000
                                    KFImage(URL(string: "https://books.google.com/books/publisher/content/images/frontcover/\(id)?fife=w1000&source=gbs_api"))
                                        .placeholder { progress in
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
                                        .shadow(color: .black.opacity(0.13), radius: 25, x: 0.0, y: 8.0)
                                }
                            }
                        }
                        .padding()
                        
                        // MARK: - Book info
                        VStack(spacing: 5){
                            // Title
                            if let title = book.title {
                                Text(title)
                                    .font(.title)
                                    .bold()
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                            }
                            
                            // Authors
                            if let authors = book.authors {
                                Text(concatAuthors(for: authors))
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        
                        Spacer(minLength: 30)
                        
                        // if the book has descriprion display it
                        if let descriptionStored = book.descriptionStored {
                            Text(descriptionStored)
                                .lineSpacing(4)
                                .kerning(0.5)
                        }
                    }
                    .padding()
                    .background(GeometryReader { geometry in
                        Color.clear // This is to see when the user scroll in the scroll view
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                            .onAppear{
                                if geometry.size.height < 600 { // If the user goes beyond 600 toogle the variables to show the action button
                                    self.isActionButtonVisible = true
                                    self.showActionButtonAtStart = true
                                }
                            }
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.scrollPosition = value
                        
                        // If the button appeared in user defaults is the first time show it
                        if defaults.bool(forKey: "buttonAppeared") == false {
                            self.isActionButtonVisible = value.y < -50
                        }
                    }
                    
                    Spacer(minLength: 60)
                }
                .coordinateSpace(name: "scroll")
                
                VStack{
                    HStack{
                        // Dismiss the full screen (description of the book)
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
                        
                        // Show options is true
                        if showOptions {
                            Menu {
                                // Button to move the book from one list to another
                                Button {
                                    // Dismiss the full screen (description of the book)
                                    dismiss()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                        withAnimation{
                                            selectedTabInLibrary = selectedTabInLibrary == .readingList ? .finishedBooks : .readingList
                                            
                                            // Search the book index
                                            if let bookIndex = books.firstIndex(where: {$0.id == book.id}){
                                                // Change the date so is the first one on the list
                                                books[bookIndex].addedDate = Date.now
                                                
                                                // Change the list
                                                books[bookIndex].list = books[bookIndex].list == "finishedList" ? "readingList" : "finishedList"
                                            }
                                        }
                                    }
                                } label: {
                                    Label("Move to \(selectedTabInLibrary == .readingList ? "finished books" : "reading list")", systemImage: selectedTabInLibrary == .readingList ? "arrow.right" : "arrow.left")
                                }
                                
                                // Button to remove the book from the library
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
                            // Confirmation dialog to ensure that the user really wants to delete the selected book
                            .confirmationDialog(
                                "Are you sure you want to delete this book?",
                                isPresented: $isConfirming, titleVisibility: .visible, presenting: dialogDetail
                            ) { detail in
                                Button(role: .destructive) {
                                    // Dismiss the full screen (description of the book)
                                    dismiss()
                                    
                                    // Add book id to the deletedBooks id (this is stored in the user defaults)
                                    if let bookId = book.id {
                                        deletedBooksIDs.append(bookId)
                                        defaults.set(deletedBooksIDs, forKey: "deletedIDs")
                                    }
                                    
                                    // Delete the book
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
                    
                    // If the flags to show the action button are true
                    if isActionButtonVisible && showActionButton{
                        Menu {
                            // Button to add the book to the finished books
                            Button{
                                addItem(with: book, listToSave: "finishedList")
                            } label: {
                                Label("Finished books", systemImage: "checkmark")
                            }
                            
                            // Button to add the book to the reading list
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
                            // When the button has already appeared change to true so that it does not disappear when scrolling up
                            defaults.set(true, forKey: "buttonAppeared")
                            
                            // Add animation the first time showing the button
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
                // Hide the status bar in the full screen
                withAnimation {
                    hideStatusBar.toggle()
                }
            }
        }
        .onAppear{
            // Set the button appear to false because will be the first time showin it
            defaults.set(false, forKey: "buttonAppeared")
            
            // Get the ids of the deleted books
            deletedBooksIDs = (defaults.array(forKey: "deletedIDs") ?? []) as? [String] ?? [""]
        }
        .statusBar(hidden: hideStatusBar)
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
    
    // Function to add a book in the given list
    private func addItem(with book: Book, listToSave: String) {
        withAnimation{
            
            // Dismiss the full screen (description of the book)
            dismiss()
            
            // Do this with a delay of 0.2s
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // Search the book index
                if let bookIndex = books.firstIndex(where: {$0.id == book.id}){
                    // Change the date so is the first one on the list
                    books[bookIndex].addedDate = Date.now
                    
                    // Change the list
                    books[bookIndex].list = listToSave
                }
                
                // Change to the libray view (2)
                self.tabSelection = 2
            }
            
            // Do this with a delay of 0.3s
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Change the selected tab in the library view
                self.selectedTabInLibrary = listToSave == "finishedList" ? .finishedBooks : .readingList
            }
        }
    }
}

#Preview {
    BookDescriptionView(book: Book(id: Optional("2zgRDXFWkm8C"), title: Optional("Harry Potter y la piedra filosofal"), authors: Optional(["J.K. Rowling"]), publisher: Optional("Pottermore Publishing"), publishedDate: Optional("2015-12-08"), descriptionStored: Optional("Con las manos temblorosas, Harry le dio la vuelta al sobre y vio un sello de lacre púrpura con un escudo de armas: un león, un águila, un tejón y una serpiente, que rodeaban una gran letra H. Harry Potter nunca había oído nada sobre Hogwarts cuando las cartas comienzan a caer en el felpudo del número cuatro de Privet Drive. Escritas en tinta verde en un pergamino amarillento con un sello morado, sus horribles tíos las han confiscado velozmente. En su undécimo cumpleaños, un hombre gigante de ojos negros llamado Rubeus Hagrid aparece con una noticia extraordinaria: Harry Potter es un mago y tiene una plaza en el Colegio Hogwarts de Magia y Hechicería. ¡Una aventura increíble está a punto de empezar! Tema musical compuesto por James Hannigan."), imageLinks: Optional(Booked.ImageLinks(smallThumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"), thumbnail: Optional("http://books.google.com/books/content?id=2zgRDXFWkm8C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"), small: nil, medium: nil, large: nil, extraLarge: nil)), categories: Optional(["Juvenile Fiction"]), averageRating: Optional(4.0), ratingsCount: Optional(124), pageCount: Optional(320), language: Optional("es"), previewLink: Optional("http://books.google.es/books?id=2zgRDXFWkm8C&printsec=frontcover&dq=harry&hl=&cd=2&source=gbs_api"), infoLink: Optional("https://play.google.com/store/books/details?id=2zgRDXFWkm8C&source=gbs_api"), list: "", addedDate: Date.now), selectedTabInLibrary: .constant(.finishedBooks), tabSelection: .constant(2), showActionButton: true)
}
