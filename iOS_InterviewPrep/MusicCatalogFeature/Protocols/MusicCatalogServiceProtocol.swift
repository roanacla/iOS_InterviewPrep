import Foundation

protocol MusicCatalogServiceProtocol {
    func search(term: String) async throws -> [CatalogItem]
}

