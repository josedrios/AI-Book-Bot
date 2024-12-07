//
//  ContentView.swift
//  AI Book Bot
//
//  Created by Jose Rios on 12/4/24.
//

// Test ISBN = 076790818X

import SwiftUI

struct ContentView: View {
    @State private var ISBNentry: String = ""
    @State private var bookData: String = ""
    @State var isLoading: Bool = false
    
    
    enum GHError: Error {
        case invalidURL
    }
    
    func dataChange(data: Data?, response: URLResponse?, error: Error?) {
        bookData = "You searched for: \(ISBNentry)"
        sleep(2)
        isLoading = false
    }
    
    func getBookInfo() {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(ISBNentry)") else {
            print("API ERROR - Invalid URL")
            return
        }
        isLoading = true
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
                
                Button(action: { getBookInfo() }) {
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
