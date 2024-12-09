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
    
    @State var ISBNentry: String = "9780767908184"
    @State var book: BookElement? = nil
    @State var isLoading: Bool = false
    var isReplaced: Bool = false
    
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
                            .foregroundColor(Color.white)
                    }
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
            .padding(.bottom, 30)
            
            // Searchbar
            HStack{
                    TextField("Enter ISBN,", text: $ISBNentry)
                    .padding(.horizontal, 10)
                    .frame(height: 50)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(5)
                    .padding(.leading)
                
                Button(action: {
                    isLoading = true
                    service.fetchLines(isbn: ISBNentry) { fetchedBook in
                    DispatchQueue.main.async {
                        self.book = fetchedBook
                        self.isLoading = false
                    }
                }
                }){
                    Text(isLoading ? "Loading..." : "Fetch Book")
                    .padding()
                    .background(isLoading ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
                .disabled(isLoading)
                .padding(.trailing)
            }
                        
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        //rgb(37,37,37)
    }
}

#Preview {
    ContentView()
}
