import SwiftUI

@Observable
class MusicCatalogViewModel {
    private let musicCatalogService: MusicCatalogServiceProtocol
    
    init(musicCatalogService: MusicCatalogServiceProtocol) {
        self.musicCatalogService = musicCatalogService
    }
}
