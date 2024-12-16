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

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    let openAI: OpenAI
    
    init(apiToken: String){
        self.openAI = OpenAI(apiToken: apiToken)
    }
    
    func sendNewMessage(content: String){
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map({.init(role: .user, content: $0.content)!
            }),
            model: .gpt3_5Turbo
        )
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice =
                    success.choices.first else {
                        return
                    }
                guard let message =
                    choice.message.content?.string
                    else { return }
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message, isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

struct ContentView: View {
    let mainColor = Color(red: 37 / 255.0, green: 37 / 255.0, blue: 37 / 255.0)
    let categories = ["SEARCH", "FINDER", "FICTION", "NON-FICTION", "BIOGRAPHY", "SCIENCE", "HISTORY", "FANTASY", "MYSTERY", "ROMANCE", "THRILLER", "SELF-HELP"]
    
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
    
    @StateObject var chatController: ChatController
    
    init() {
        guard let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "API_KEY"
        ) as? String else {
            fatalError("Could not find your API key in Info.plist")
        }
        _chatController = StateObject(wrappedValue: ChatController(apiToken: apiKey))
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
            VStack {
                ScrollView {
                    ForEach(chatController.messages) {
                        message in
                        MessageView(message: message)
                            .padding(5)
                    }
                }
                Divider()
                HStack {
                    TextField("Message...", text: self.$string, axis: .vertical)
                        .padding(5)
                        .background(Color.gray.opacity(0.1))
                    Button {
                        self.chatController.sendNewMessage(content: string)
                        string = ""
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                .padding()
                .background(Color.white)
            }
        }
        .background(mainColor)
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
                } else {
                    title = "{ TITLE }"
                    isbn = "{ ID }"
                    pages = 0
                    authors = ["{ HUMAN }"]
                    summary = "{ AI LINGO }"
                }
                self.isLoading = false
            }
        }
    }
}

struct MessageView: View {
    var message: Message
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                    Spacer()
                }
            }
        }
    }
}

struct Header: View {
    var body: some View {
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

struct Search: View {
    @Binding var ISBNentry: String
    @Binding var isLoading: Bool
    var fetchBook: () -> Void

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if ISBNentry.isEmpty {
                    Text("Enter ISBN")
                        .foregroundColor(Color.white.opacity(0.4))
                        .font(.custom("SpaceMono-Regular", size: 17))
                        .padding(.leading, 5)
                }
                TextField("", text: $ISBNentry)
                    .foregroundColor(Color.white)
                    .font(.system(.title3, design: .monospaced))
                    .tint(Color.white)
                    .frame(height: 50)
                    .cornerRadius(5)
                    .padding(.leading, 5)
            }
            .padding(.leading, 10)
            
            Button(action: {
                isLoading = true
                fetchBook()
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundColor(isLoading ? Color.gray : Color.white.opacity(0.8))
                    .padding(.leading, 0)
                    .padding(.trailing, 10)
            }
            .disabled(isLoading)
        }
        .background(Color.white.opacity(0.2))
        .cornerRadius(5)
        .padding(.horizontal)
        .padding(.top, 5)
    }
}

struct Navbar: View {
    @Binding var currentCat: String
    let categories: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        currentCat = category
                        print("'\(category)' category was clicked")
                    }) {
                        Text(category)
                            .font(.custom("SpaceMono-Regular", size: 18))
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
    }
}

struct BodySection: View {
    @Binding var currentCat: String
    let categories: [String]
    let title: String
    let isbn: String
    let pages: Int
    let authors: [String]
    let summary: String

    var body: some View {
        TabView(selection: $currentCat){
                ForEach(categories, id:\.self){ category in
                    if category == "SEARCH" {
                        SearchTab(
                            category: category,
                            title: title,
                            isbn: isbn,
                            pages: pages,
                            authors: authors,
                            summary: summary
                        )
                    }else{
                        CategoryTab(
                            currentCat: $currentCat,
                            category: category
                        )
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SearchTab: View {
    let category: String
    let title: String
    let isbn: String
    let pages: Int
    let authors: [String]
    let summary: String

    var body: some View {
        ScrollView{
                        VStack(spacing: 0) {
                            VStack(spacing: 0) {
                                Text("\(title.isEmpty ? "{ TITLE }" : title)")
                                    .foregroundColor(Color.white)
                                    .font(.custom("SpaceMono-Regular", size: 30))
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 20)
                                    .padding(.top, 0)
            
                                VStack(spacing: 0) {
                                    Text("ISBN: \(isbn.isEmpty ? "{ ID }" : isbn)")
                                        .foregroundColor(Color.white)
                                        .font(.custom("SpaceMono-Regular", size: 20))
                                        .padding(.top, 10)
                                        .padding(.bottom, 5)
            
                                    Text("Authors: \(authors.isEmpty ? "{ HUMAN }" : authors.joined(separator: ", "))")
                                        .foregroundColor(Color.white)
                                        .font(.custom("SpaceMono-Regular", size: 20))
                                        .padding(.bottom, 5)
            
                                    Text("Pages: \(pages == 0 ? "{ NUMBER }" : "\(pages)")")
                                        .foregroundColor(Color.white)
                                        .font(.custom("SpaceMono-Regular", size: 20))
                                        .padding(.bottom, 5)
                                    Text("Summary: \(summary == "" ? "{ AI LINGO }" : "\(summary)")")
                                        .foregroundColor(Color.white)
                                        .font(.custom("SpaceMono-Regular", size: 20))
                                        .padding(.bottom, 5)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tag(category)
    }
}

struct CategoryTab: View {
    @Binding var currentCat: String
    let category: String
    var body: some View {
        ScrollView{
            Text(category)
                .foregroundColor(Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tag(category)
    }
}


#Preview {
    ContentView()
}
