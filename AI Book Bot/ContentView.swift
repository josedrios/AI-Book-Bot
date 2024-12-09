//
//  ContentView.swift
//  AI Book Bot
//
//  Created by Jose Rios on 12/4/24.
//

// Test ISBN = 076790818X
// Test ISBN = 9781590302484

import SwiftUI

struct ContentView: View {
    let mainColor = Color(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0)
    let categories = ["Result" , "Fiction", "Non-fiction", "Biography", "Science", "History", "Fantasy", "Mystery", "Romance", "Thriller", "Self-help"]
    
    let service = BookService()
    
    @State var ISBNentry: String = ""
    @State var book: BookElement? = nil
    @State var isLoading: Bool = false
    @State var currentCat: String = "Result"
    
    var body: some View {
        VStack(spacing:0) {
            // Headerbar
            ZStack{
                HStack {
                    Button(action: {
                        print("Pressed navbar button")
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 25, height: 18)
                            .font(.title)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(Color.white)
                    .padding(.leading,20)
                    Spacer()
                }
                HStack(alignment:.bottom, spacing: 2){
                    Text("READ")
                        .font(.system(.title, design: .monospaced))
                        .foregroundColor(Color.white)
                    Text("AI")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 10)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 7)
            .padding(.bottom, 15)
            
            // Searchbar
            HStack{
                ZStack(alignment: .leading) {
                    if ISBNentry.isEmpty {
                        Text("Enter ISBN")
                            .foregroundColor(Color.white.opacity(0.4))
                            .font(.system(.headline, design: .monospaced))
                            .padding(.leading,(5))
                    }
                    TextField("", text: $ISBNentry)
                        .foregroundColor(Color.white)
                        .font(.system(.title3, design: .monospaced))
                        .tint(Color.white)
                        .frame(height: 50)
                        .cornerRadius(5)
                        .padding(.leading,(5))
                }
                .padding(.leading,10)

                
                Button(action: {
                    isLoading = true
                    service.fetchLines(isbn: ISBNentry) { fetchedBook in
                    DispatchQueue.main.async {
                        if let book = fetchedBook {
                            self.book = book
                        } else {
                            self.book = nil
                        }
                        self.isLoading = false
                    }
                }
                }){
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                        .foregroundColor(isLoading ? Color.gray: Color.white.opacity(0.8))
                        .padding(.leading, 0)
                        .padding(.trailing, 10)
                }
                .disabled(isLoading)
            }
            .background(Color.white.opacity(0.2))
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.top, 5)
            
            // Navbar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(categories, id: \.self) {category in
                        Button(action: {
                            currentCat = category
                            print("'\(category)' category was clicked")
                        }){
                            Text(category)
                                .font(.system(.headline, design: .monospaced))
                                .foregroundColor(currentCat == category ? Color.white : Color.white.opacity(0.5))
                        }
                        .frame(height: 50)
                        .overlay(
                            Rectangle()
                                .fill(currentCat == category ? Color.white : Color.white.opacity(0.4))
                                .frame(height: 3)
                                .padding(.top, 50),
                                alignment: Alignment.bottom
                        )
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.top, 10)
            .padding(.horizontal)
            
            // Body
            if(isLoading) {
                ProgressView()
                    .tint(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(5)
                    .padding()
            } else {
                if let book = book {
                    VStack{
                        Text("Title: \(book.title)")
                        if let numPages = book.numPages {
                            Text("Number of Pages: \(numPages)")
                        }
                        if let authors = book.authors {
                            Text("Authors: \(authors.map { $0.name }.joined(separator: ", "))")
                        }
                        Spacer()
                    }
                    .frame(width: .infinity, height: .infinity)
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding()
                } else {
                    Text("No book details available")
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(5)
                        .padding()
                }
            }
        }
        .background(mainColor)
    }
}

#Preview {
    ContentView()
}
