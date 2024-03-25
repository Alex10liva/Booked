//
//  SingleBookCard.swift
//  Booked
//
//  Created by Alejandro Oliva Ochoa on 25/03/24.
//

import SwiftUI

struct SingleBookCard: View {
    
    let bookInfo: String = ""
    
    var body: some View {
        VStack{
            Image("harry")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary.opacity(0.3), lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.13), radius: 25, x: 0.0, y: 8.0)
            
            
            VStack(spacing: 5){
                Text("Harry Potter and the Philosopher’s Stone")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                    .lineLimit(2)
                
                Text("J. K. Rowling")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text("There will be three tasks, spaced throughout the school year, and they will test the champions in many different ways ... their magical prowess - their daring - their powers of deduction - and, of course, their ability to cope with danger.' The Triwizard Tournament is to be held at Hogwarts. Only wizards who are over seventeen are allowed to enter - but that doesn't stop Harry dreaming that he will win the competition. Then at Hallowe'en, when the Goblet of Fire makes its selection, Harry is amazed to find his name is one of those that the magical cup picks out. He will face death-defying tasks, dragons and Dark wizards, but with the help of his best friends, Ron and Hermione, he might just make it through - alive! Having become classics of our time, the Harry Potter eBooks never fail to bring comfort and escapism. With their message of hope, belonging and the enduring power of truth and love, the story of the Boy Who Lived continues to delight generations of new readers.")
                .lineLimit(2)
                .foregroundStyle(
                    LinearGradient(colors: [.primary, .primary.opacity(0)], startPoint: .top, endPoint: .bottom)
                )
        }
        .padding()
    }
}

#Preview {
    SingleBookCard()
}
