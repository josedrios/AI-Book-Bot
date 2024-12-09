import Foundation

struct BookService {
    func fetchLines(isbn: String, onLinesReturned callback: @escaping (BookElement?) -> Void) {
        guard let url = URL(string: "https://openlibrary.org/api/books?bibkeys=ISBN:\(isbn)&jscmd=details&format=json") else {
            print("Book API URL not working...")
            callback(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received")
                callback(nil)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([String: BookWrapper].self, from: data)
                if let bookWrapper =  decodedData["ISBN:\(isbn)"] {
                    callback(bookWrapper.details)
                }else {
                    print("No book details found")
                    callback(nil)
                }
            }catch {
                print("Error decoding json")
                callback(nil)
            }
        }.resume()
    }
}

struct BookWrapper: Decodable {
    let details: BookElement
}

