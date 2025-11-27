import Foundation

enum MusicCatalogServiceError: Error {
    case noDataReturned
    case noResponse
    case invalidURL
}

class ITunesCatalogService: MusicCatalogServiceProtocol {
    private enum EndPoint: String {
        case itunesSearchURL = "https://itunes.apple.com/search?media=music&entity=song&term="
    }
    
    func search(term: String) async throws -> [CatalogItem] {
        let endPoint = EndPoint.itunesSearchURL.rawValue + term
        guard let url = URL(string: endPoint) else {
            throw MusicCatalogServiceError.invalidURL
        }
        
        let urlSession = URLSession.shared
        let request = URLRequest(url: url)
        let (data, response) = try await urlSession.data(for: request)
        
        guard let response = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(response) else {
            throw MusicCatalogServiceError.noResponse
        }
        
        let jsonDecoder = JSONDecoder()
        let iTunesSearchResponse = try jsonDecoder.decode(ITunesSearchResponse.self, from: data)
        
        return iTunesSearchResponse.results
    }
}
