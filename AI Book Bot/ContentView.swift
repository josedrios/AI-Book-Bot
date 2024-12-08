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
    @State var bookData: String = ""
    @State var isLoading: Bool = false
    // 9781590302484
    
    var body: some View {
        VStack {
            HStack{
                TextField("Enter ISBN,", text:$ISBNentry)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                Button(action: {
                    service.fetchLines(isbn: ISBNentry,onLinesReturned: {(book: BookElement) in
                        print("Title: \(book.title)")
                        print("Number of Pages: \(book.numPages)")
                        if let authors = book.authors {
                            for author in authors {
                                print("Authors: \(author.name)")
                            }
                        } else {
                            print("Authors: Unknown")
                        }
                    })
                }) {
                    Text("Enter")
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
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .padding()
            } else {
                Text(bookData)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
