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
        defer { isLoading = false }
        isLoading = true
        do {
            items = try await musicCatalogService.search(term: searchText)
        } catch (let error as MusicCatalogServiceError) {
            switch error {
            case .invalidSearchTerm:
                errorMessage = "Please enter a valid search term."
            case .noDataReturned:
                errorMessage = "No data returned for the given search term."
            case .noResponse:
                errorMessage = "No response from the server."
            case .invalidURL:
                errorMessage = "The URL is invalid."
            }
        } catch (let error as DecodingError) {
            switch error {
            case .dataCorrupted:
                errorMessage = "Data is corrupted."
            @unknown default:
                errorMessage = "Failed to decode the response."
            }
        } catch {
            errorMessage = "Unknown error"
        }
    }
}
