import Foundation

struct BookService {
    func fetchLines(isbn: String, decider: Int, onLinesReturned callback: @escaping (BookElement?) -> Void) {
        if decider != 0 {
            let searchURL = "https://openlibrary.org/search.json?title=\(isbn.replacingOccurrences(of: " ", with: "+"))"
            
            guard let url = URL(string: searchURL) else {
                print("Invalid search URL")
                callback(nil)
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    print("Error fetching ISBN: \(error?.localizedDescription ?? "Unknown error")")
                    callback(nil)
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(TitleSearchResult.self, from: data)
                    if let firstDoc = decodedData.docs.first, let firstISBN = firstDoc.isbn?.first {
                        print("First ISBN: \(firstISBN)")
                        self.fetchBookDetails(isbn: firstISBN, callback: callback)
                    } else {
                        print("No ISBN found for title: \(isbn)")
                        callback(nil)
                    }
                } catch {
                    print("Error decoding search JSON: \(error)")
                    callback(nil)
                }
            }.resume()
            
        } else {
            fetchBookDetails(isbn: isbn, callback: callback)
        }
    }
    
    private func fetchBookDetails(isbn: String, callback: @escaping (BookElement?) -> Void) {
        let detailsURL = "https://openlibrary.org/api/books?bibkeys=ISBN:\(isbn)&jscmd=details&format=json"
        
        guard let url = URL(string: detailsURL) else {
            print("Invalid book details URL")
            callback(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching book details: \(error?.localizedDescription ?? "Unknown error")")
                callback(nil)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([String: BookWrapper].self, from: data)
                if let bookWrapper = decodedData["ISBN:\(isbn)"] {
                    callback(bookWrapper.details)
                } else {
                    print("No book details found for ISBN: \(isbn)")
                    callback(nil)
                }
            } catch {
                print("Error decoding book details JSON: \(error)")
                callback(nil)
            }
        }.resume()
    }
}

struct BookWrapper: Decodable {
    let details: BookElement
}

