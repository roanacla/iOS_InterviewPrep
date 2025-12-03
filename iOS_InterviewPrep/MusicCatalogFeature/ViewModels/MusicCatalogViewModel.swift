import SwiftUI

enum MusicCatalogViewModelError: String, Identifiable, Error {
    case networkIssue = "Network issue. Please try again."
    case dataCorrupted = "Data corrupted. Please try again."
    
    var id: String {
        rawValue
    }
}

@MainActor
@Observable
class MusicCatalogViewModel {
    private let musicCatalogService: MusicCatalogServiceProtocol
    var searchText: String = "Taylor Swift"
    var items: [CatalogItem] = []
    var isLoading = false
    var presentedError: MusicCatalogViewModelError?
    
    init(musicCatalogService: MusicCatalogServiceProtocol) {
        self.musicCatalogService = musicCatalogService
    }
    
    func searchMusic() async {
        defer { isLoading = false }
        isLoading = true
        
        do {
            items = try await musicCatalogService.search(term: searchText)
        } catch {
            presentedError = .networkIssue
        }
    }
}
