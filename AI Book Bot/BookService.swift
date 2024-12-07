import Foundation

struct BookService {
    func fetchLines(onLinesReturned callback: @escaping (String) -> Void) {
        guard let url = URL(string: "https://openlibrary.org/api/books?bibkeys=ISBN%3A9781590302484&jscmd=details&format=json") else {
            // Error handling
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                // Error handling
                return
            }
            guard let jsonString = String(data: data, encoding: .utf8) else {
                // error handling
                return
            }
            callback(jsonString)
        }.resume()
    }
}

