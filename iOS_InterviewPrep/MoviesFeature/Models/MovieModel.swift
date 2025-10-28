import Foundation

struct Movie: Codable, Hashable {
    var title: String
    let year: String
    let imdbID: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case poster = "Poster"
    }
}

struct Search: Codable {
    var movies: [Movie] = []
    let totalResults: String = "0"
    let response: String = ""
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
}
