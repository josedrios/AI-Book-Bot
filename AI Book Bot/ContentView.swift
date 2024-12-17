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
    
    @State var ISBNentry: String = "0316017922"
    @State var titleArray = Array(repeating: "", count: 11)
    @State var isbnArray = Array(repeating: "", count: 11)
    @State var pagesArray = Array(repeating: 0, count: 11)
    @State var authorsArray = Array(repeating: "", count: 11)
    @State var prompt: String = ""
    @State var summaryArray = Array(repeating: "", count: 11)
    
    @State var isLoading: Bool = false
    @State var recommendedISBN: String = ""
    @State var ISBNprompt: String = ""
    @State var currentCat: String = "SEARCH"
    @State var currentIndex: Int = 0
    
    @State private var overlayOn = false
    
    init() {
        guard let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "API_KEY"
        ) as? String else {
            fatalError("Could not find your API key in Info.plist")
        }
        _AIcontroller = StateObject(wrappedValue: AIController(apiToken: apiKey))
    }
    
    var body: some View {
        
        ZStack{
            VStack(spacing:0) {
                Header(overlayOn: $overlayOn)
                
                Search(ISBNentry: $ISBNentry, isLoading: $isLoading, currentCat: $currentCat) {_ in
                    fetchISBN(for: 0)
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
                ) {_ in
                    fetchISBN(for: currentIndex)
                }
            }
            .background(mainColor)
            .ignoresSafeArea(edges: .bottom)
            
            if overlayOn {
                ZStack {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            overlayOn = false
                        }
                    
                    VStack {
                        Text("Settings")
                            .font(.custom("SpaceMono-Regular", size:30))
                            .foregroundColor(Color.white)
                            .padding()
                        Text("Testig my overlay")
                            .padding()
                        Button(action: {
                            overlayOn = false
                        }) {
                            Text("Close")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: .infinity, height: .infinity)
                    .background(mainColor)
                    .shadow(radius: 10)
                }
                .zIndex(1)
            }
        }
    }
    
    func fetchISBN(for index: Int) {
        if index == 0 {
            ISBNprompt = ISBNentry
            fetchBook(for: index)
        }else{
            let suggestion = "Only provide a valid, popular book title in the category \(categories[index]) in english. The book must be recognizable and widely published. Do not provide any other text or description or author detail, just the title."
            AIcontroller.sendNewMessage(content: suggestion) { reply in
                DispatchQueue.main.async {
                    recommendedISBN = reply ?? "0"
                    print("BOOK TITLE: \(recommendedISBN)")
                    ISBNprompt = recommendedISBN
                    fetchBook(for: index)
                }
            }
        }
    }
    
    func fetchBook(for index: Int) {
        service.fetchLines(isbn: ISBNprompt, decider: index) { fetchedBook in
            DispatchQueue.main.async {
                if let book = fetchedBook {
                    titleArray[index] = book.title
                    isbnArray[index] = ISBNentry
                    pagesArray[index] = book.numPages ?? 0
                    authorsArray[index] = book.authors?.first?.name
                    ?? book.contributors?.first?.name
                    ?? "{ HUMAN }"
                    prompt = "Give me a concise summary of the book \(titleArray[index])"
                    
                    AIcontroller.sendNewMessage(content: prompt) { reply in
                        summaryArray[index] = "..."
                        DispatchQueue.main.async {
                            summaryArray[index] = reply ?? "No summary available"
                        }
                    }
                } else {
                    titleArray[index] = "{ NO RESULT, TRY AGAIN }"
                    isbnArray[index] = "{ \(ISBNprompt) }"
                    pagesArray[index] = 404
                    authorsArray[index] = "{ TRY ANOTHER ISBN }"
                    summaryArray[index] = "{ AI SAID SORRY... OR SOMETHING LIKE THAT... }"
                }
                self.isLoading = false
            }
        }
    }
}


#Preview {
    ContentView()
}
