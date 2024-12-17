//  ContentView.swift
//  AI Book Bot
//  Created by Jose Rios on 12/4/24.
// Test ISBN = 076790818X
// Test ISBN = 9781590302484
// 9780062316110

import SwiftUI
import OpenAI

struct ContentView: View {
    let mainColor = Color(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0)
    let categories = ["SEARCH", "FICTION", "NON-FICTION", "BIOGRAPHY", "SCIENCE", "HISTORY", "FANTASY", "MYSTERY", "ROMANCE", "THRILLER", "SELF-HELP"]
    
    let service = BookService()
    @StateObject var AIcontroller: AIController
    
    @State var ISBNentry: String = "9781590302484"
    @State var titleArray = Array(repeating: "", count: 11)
    @State var isbnArray = Array(repeating: "", count: 11)
    @State var pagesArray = Array(repeating: 0, count: 11)
    @State var authorsArray = Array(repeating: "", count: 11)
    @State var prompt: String = ""
    @State var summaryArray = Array(repeating: "", count: 11)
    
    @State var isLoading: Bool = false
    @State var currentCat: String = "SEARCH"
    @State var currentIndex: Int = 0
    
    init() {
        guard let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "API_KEY"
        ) as? String else {
            fatalError("Could not find your API key in Info.plist")
        }
        _AIcontroller = StateObject(wrappedValue: AIController(apiToken: apiKey))
    }
    
    var body: some View {
        VStack(spacing:0) {
            Header()
            
            Search(ISBNentry: $ISBNentry, isLoading: $isLoading) {
                fetchBook()
            }
            
            Navbar(currentCat: $currentCat, currentIndex: $currentIndex, categories: categories)
            
            BodySection(
                currentCat: $currentCat,
                currentIndex: $currentIndex,
                categories: categories,
                titleArray: titleArray,
                isbnArray: isbnArray,
                pagesArray: pagesArray,
                authorsArray: authorsArray,
                summaryArray: summaryArray
            )
        }
        .background(mainColor)
        .ignoresSafeArea(edges: .bottom)
    }
    
    func fetchBook() {
        service.fetchLines(isbn: ISBNentry) { fetchedBook in
            DispatchQueue.main.async {
                if let book = fetchedBook {
                    titleArray[currentIndex] = book.title
                        isbnArray[currentIndex] = ISBNentry
                        pagesArray[currentIndex] = book.numPages ?? 0
                        authorsArray[currentIndex] = book.authors?.first?.name
                            ?? book.contributors?.first?.name
                            ?? "{ HUMAN }"
                        prompt = "Give me a concise summary of the book \(titleArray[0])"
                        
                        AIcontroller.sendNewMessage(content: prompt) { reply in
                            summaryArray[currentIndex] = "..."
                            DispatchQueue.main.async {
                                summaryArray[currentIndex] = reply ?? "No summary available"
                            }
                        }
                } else {
                    titleArray[currentIndex] = "{ ERROR - TRY ANOTHER IBSN }"
                    isbnArray[currentIndex] = "{ - }"
                    pagesArray[currentIndex] = 0
                    authorsArray[currentIndex] = "{ - }"
                    summaryArray[currentIndex] = "{ - }"
                }
                self.isLoading = false
            }
        }
    }
}


#Preview {
    ContentView()
}
