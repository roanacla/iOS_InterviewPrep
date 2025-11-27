import Foundation

enum MusicCatalogServiceError: Error {
    case invalidSearchTerm
    case noDataReturned
    case noResponse
    case invalidURL
}

class ITunesCatalogService: MusicCatalogServiceProtocol {
    private enum EndPoint: String {
        case itunesSearchURL = "https://itunes.apple.com/search?media=music&entity=song&term="
    }
    lazy var urlSession: URLSession = .shared
    lazy var jsonDecoder = JSONDecoder()
    
    func search(term: String) async throws -> [CatalogItem] {
        guard let term = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw MusicCatalogServiceError.invalidSearchTerm
        }
        let endPoint = EndPoint.itunesSearchURL.rawValue + term
        guard let url = URL(string: endPoint) else {
            throw MusicCatalogServiceError.invalidURL
        }
        
        let request = URLRequest(url: url)
        let (data, response) = try await urlSession.data(for: request)
        
        guard let response = (response as? HTTPURLResponse)?.statusCode, response == 200 else {
            throw MusicCatalogServiceError.noResponse
        }
        
        let iTunesSearchResponse = try jsonDecoder.decode(ITunesSearchResponse.self, from: data)
        
        return iTunesSearchResponse.results
    }
}
