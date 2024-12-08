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
    
    let service = BookService()
    
    @State var ISBNentry: String = "9780767908184"
    @State var book: BookElement? = nil
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            HStack{
                TextField("Enter ISBN,", text:$ISBNentry)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
            .padding(.top)
                        
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
        .background(Color.purple)
    }
}

#Preview {
    ContentView()
}
