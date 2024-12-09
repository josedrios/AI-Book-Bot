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
    
    let service = BookService()
    
    @State var ISBNentry: String = ""
    @State var book: BookElement? = nil
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing:0) {
            // Navbar
            ZStack{
                HStack {
                    Button(action: {
                        print("Pressed navbar button")
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 30, height: 18)
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
            .padding(.top, 5)
            .padding(.bottom, 12)
            
            // Searchbar
            HStack{
                ZStack(alignment: .leading) {
                    if ISBNentry.isEmpty {
                        Text("Enter ISBN")
                            .foregroundColor(Color.white.opacity(0.4))
                            .font(.system(.title3, design: .monospaced))
                    }
                    TextField("", text: $ISBNentry)
                        .foregroundColor(Color.white)
                        .font(.system(.title3, design: .monospaced))
                        .tint(Color.white)
                        .frame(height: 50)
                        .cornerRadius(5)
                }
                .padding(.leading,10)

                
                Button(action: {
                    isLoading = true
                    service.fetchLines(isbn: ISBNentry) { fetchedBook in
                    DispatchQueue.main.async {
                        self.book = fetchedBook
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
            .padding()
            .padding(.top, 0)
            .padding(.bottom, 0)
            
            
            // Body
            if(isLoading) {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
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
