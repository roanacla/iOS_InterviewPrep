import SwiftUI

@MainActor
@Observable
class MusicCatalogViewModel {
    private let musicCatalogService: MusicCatalogServiceProtocol
    var searchText: String = "Taylor Swift"
    var items: [CatalogItem] = []
    var isLoading = false
    var errorMessage = ""
    
    init(musicCatalogService: MusicCatalogServiceProtocol) {
        self.musicCatalogService = musicCatalogService
    }
    
    func searchMusic() async {
        errorMessage = ""
        defer { isLoading = false }
        isLoading = true
        
        do {
            items = try await musicCatalogService.search(term: searchText)
        } catch {
            errorMessage = "Failure to fetch music. Please try again."
        }
    }
}
