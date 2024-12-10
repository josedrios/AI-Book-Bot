//
//  ContentView.swift
//  AI Book Bot
//
//  Created by Jose Rios on 12/4/24.
//

// Test ISBN = 076790818X
// Test ISBN = 9781590302484
// 9780062316110

import SwiftUI

struct ContentView: View {
    let mainColor = Color(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0)
    let categories = ["SEARCH", "FICTION", "NON-FICTION", "BIOGRAPHY", "SCIENCE", "HISTORY", "FANTASY", "MYSTERY", "ROMANCE", "THRILLER", "SELF-HELP"]
    
    let service = BookService()
    
    @State var ISBNentry: String = ""
    @State var book: BookElement? = nil
    @State var isLoading: Bool = false
    @State var currentCat: String = "SEARCH"
    
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
                    .padding(.top, 3)
                    Spacer()
                }
                HStack(alignment:.bottom, spacing: 2){
                    Text("READ")
                        .font(.custom("SpaceMono-Regular", size:30))
                        .foregroundColor(Color.white)
                    Text("AI")
                        .font(.custom("SpaceMono-Regular", size:20))
                        .foregroundColor(Color.white)
                        .padding(.bottom, 18)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 3)
            .padding(.bottom, 15)
            
            // Searchbar
            HStack{
                ZStack(alignment: .leading) {
                    if ISBNentry.isEmpty {
                        Text("Enter ISBN")
                            .foregroundColor(Color.white.opacity(0.4))
                            .font(.custom("SpaceMono-Regular", size:17))
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
                    currentCat = "Search"
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
                                .font(.custom("SpaceMono-Regular", size:17))
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
            .padding(.horizontal)
            
            // Body
            ScrollView{
                VStack(spacing: 0){
                    Text("The Book of 5 Rings Artist Program")
                        .foregroundColor(Color.white)
                        .font(.custom("SpaceMono-Regular", size:27))
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 5)
                .cornerRadius(5)
                .overlay(
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 2)
                        .padding(.top, 50),
                        alignment: Alignment.bottom
                )
                
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
                            } else {
                                if let contributors = book.contributors {
                                    Text("Authors: \(contributors.map { $0.name }.joined(separator: ", "))")
                                }
                            }
                            Spacer()
                        }
                        .background(Color.green)
                        .foregroundStyle(Color.white)
                        .padding()
                    } else {
                        Text("No book details available")
                            .foregroundStyle(Color.white)
                            .padding()
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
        .background(mainColor)
    }
}

#Preview {
    ContentView()
}
