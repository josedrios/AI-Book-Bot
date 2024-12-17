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
import OpenAI

struct ContentView: View {
    let mainColor = Color(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0)
    let categories = ["SEARCH", "FICTION", "NON-FICTION", "BIOGRAPHY", "SCIENCE", "HISTORY", "FANTASY", "MYSTERY", "ROMANCE", "THRILLER", "SELF-HELP"]
    
    let service = BookService()
    
    @State var ISBNentry: String = "9781590302484"
    
    @State var title: String = ""
    @State var isbn: String = ""
    @State var pages: Int = 0
    @State var authors: [String] = []
    @State var prompt: String = ""
    
    @State var summary: String = ""
    
    @State var isLoading: Bool = false
    @State var currentCat: String = "SEARCH"
    
    @StateObject var AIcontroller: AIController
    
    init() {
        guard let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "API_KEY"
        ) as? String else {
            fatalError("Could not find your API key in Info.plist")
        }
        _AIcontroller = StateObject(wrappedValue: AIController(apiToken: apiKey))
    }
    
    @State var string: String = ""
    
    var body: some View {
        VStack(spacing:0) {
            Header()
            
            Search(ISBNentry: $ISBNentry, isLoading: $isLoading) {
                fetchBook()
            }
            
            Navbar(currentCat: $currentCat, categories: categories)
            
            BodySection(
                currentCat: $currentCat,
                categories: categories,
                title: title,
                isbn: isbn,
                pages: pages,
                authors: authors,
                summary: summary
            )
        }
        .background(mainColor)
        .ignoresSafeArea(edges: .bottom)
    }
    
    func fetchBook() {
        service.fetchLines(isbn: ISBNentry) { fetchedBook in
            DispatchQueue.main.async {
                if let book = fetchedBook {
                    title = book.title
                        isbn = ISBNentry
                        pages = book.numPages ?? 0
                        authors = book.authors?.map { $0.name } ?? book.contributors?.map { $0.name } ?? ["{ HUMAN }"]
                        prompt = "Give me a concise summary of the book \(title)"
                        
                        AIcontroller.sendNewMessage(content: prompt) { reply in
                            summary = "..."
                            DispatchQueue.main.async {
                                summary = reply ?? "No summary available"
                            }
                        }
                } else {
                    title = "{ TITLE }"
                    isbn = "{ ID }"
                    pages = 0
                    authors = ["{ HUMAN }"]
                    summary = "{ AI WISDOM }"
                }
                self.isLoading = false
            }
        }
    }
}


#Preview {
    ContentView()
}
