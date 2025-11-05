import Foundation
import UIKit

enum MetSearchError: Error {
    case invalidURL
    case invalidResponse
//    case invalid
}

class MetNetworkService {
    //TODO: Add property to share JSONDecoder, URLSession
    
    func fetchObjects(query: String) async throws -> MetSearchResult {
        let searchEndPoint = "https://collectionapi.metmuseum.org/public/collection/v1/search?q=\(query)"
        
        let searchURL = URL(string: searchEndPoint)
        guard let searchURL else {
            throw MetSearchError.invalidURL
        }
        let request = URLRequest(url: searchURL)
        let urlSession = URLSession.shared
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
            throw MetSearchError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(MetSearchResult.self, from: data)
    }
    
    func fetchObject(endpoint: String) async throws -> MetObject {
        let objectEndPoint = endpoint
        
        let searchURL = URL(string: objectEndPoint)
        guard let searchURL else {
            throw MetSearchError.invalidURL
        }
        let request = URLRequest(url: searchURL)
        let urlSession = URLSession.shared
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
            throw MetSearchError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(MetObject.self, from: data)
    }
    
    func fetchObjectImage(endpoint: String) async throws -> UIImage? {
        let imageEndPoint = endpoint
        
        let imageURL = URL(string: imageEndPoint)
        guard let imageURL else {
            throw MetSearchError.invalidURL
        }
        let request = URLRequest(url: imageURL)
        let urlSession = URLSession.shared
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
            throw MetSearchError.invalidResponse
        }
        
        return UIImage(data: data)
    }
}
