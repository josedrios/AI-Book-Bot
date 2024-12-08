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
    
    @State var ISBNentry: String = "9781590302484"
    
    @State var title: String = ""
    @State var isbn: String = ""
    @State var pages: Int = 0
    @State var authors: [String] = []
    
    @State var isLoading: Bool = false
    @State var currentCat: String = "SEARCH"
    
    
    
    var body: some View {
        VStack(spacing:0) {
            Header()
            
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
                    currentCat = "SEARCH"
                    service.fetchLines(isbn: ISBNentry) { fetchedBook in
                    DispatchQueue.main.async {
                        if let book = fetchedBook {
                            title = book.title
                            isbn = ISBNentry
                            pages = book.numPages ?? 0
                            authors = book.authors?.map { $0.name } ?? book.contributors?.map { $0.name } ?? [" {HUMAN } "]
                        } else {
                            title = "{ TITLE }"
                            isbn = "{ ID }"
                            pages = 00
                            authors = ["{ HUMAN }"]
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
                                .font(.custom("SpaceMono-Regular", size:18))
                                .foregroundColor(currentCat == category ? Color.white : Color.white.opacity(0.4))
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
                        .disabled(currentCat == category)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 0)
                        
            // Body
            ScrollView{
                VStack(spacing: 0){
                    VStack(spacing: 0){
                        Text("\(title == "" ? "{ TITLE }" : "\(title)")")
                            .foregroundColor(Color.white)
                            .font(.custom("SpaceMono-Regular", size:30))
                            .padding(.horizontal, 10)
                            .padding(.bottom, 20)
                            .padding(.top, 0)

                        VStack(spacing: 0){
                            Text("ISBN: \(isbn == "" ? "{ ID }" : isbn)")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size:20))
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                            Text("Authors: \(authors.isEmpty ? "{ HUMAN }" : authors.joined(separator: ", "))")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size:20))
                                .padding(.bottom, 5)
                            Text("Pages: \(pages == 0 ? "{ NUMBER }" : "\(pages)")")
                                .foregroundColor(Color.white)
                                .font(.custom("SpaceMono-Regular", size:20))
                                .padding(.bottom, 15)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
                }
                .padding(.top, 15)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .cornerRadius(5)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .background(mainColor)
    }
}

struct Header: View {
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
