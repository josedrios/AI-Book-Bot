//
//  ContentView.swift
//  AI Book Bot
//
//  Created by Jose Rios on 12/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var ISBNentry: String = ""
    @State private var bookData: String = ""
    
    enum GHError: Error {
        case invalidURL
    }
    
    func dataChange(data: Data?, response: URLResponse?, error: Error?) {
        bookData = "You searched for: \(ISBNentry)"
    }
    
    func getBookInfo() {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(ISBNentry)") else {
            print("API ERROR - Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: dataChange
        )
        task.resume()
        
    }
    
    var body: some View {
        VStack {
            HStack{
                TextField("Enter ISBN,", text:$ISBNentry)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                Button(action: {
                    getBookInfo()
                }){
                    Text("Enter")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding(.trailing)
            }
            .padding(.top)
                        
            Text(bookData)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
