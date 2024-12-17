//
//  BookElement.swift
//  AI Book Bot
//
//  Created by Jose Rios on 12/7/24.
//

import Foundation

struct BookElement: Decodable {
    let title: String
    let numPages: Int?
    let authors: [Author]?
    let contributors: [Contributor]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case numPages = "number_of_pages"
        case authors
        case contributors
    }
}

struct Author: Decodable {
    let name: String
}
struct Contributor: Decodable {
    let role: String
    let name: String
}

struct BookDoc: Decodable {
    let isbn: [String]?
}

struct TitleSearchResult: Decodable {
    let docs: [BookDoc]
}
