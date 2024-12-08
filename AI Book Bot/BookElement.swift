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
    
    enum CodingKeys: String, CodingKey {
        case title
        case numPages = "number_of_pages"
        case authors
    }
}

struct Author: Decodable {
    let name: String
}
