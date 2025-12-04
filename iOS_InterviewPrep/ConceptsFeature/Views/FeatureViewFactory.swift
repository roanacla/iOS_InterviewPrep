import SwiftUI

struct FeatureViewFactory {
    @ViewBuilder
    static func view(for concept: Concept) -> some View {
        switch concept.subject {
        case .conectedFour:
            ConectedFourView()
        case .searchMovies:
            MovieSearchView(viewModel: SearchViewModel())
        case .metMuseum:
            // Resolve the MetNetworkService from the container.
            let metService = DependencyContainer.shared.resolve(MetNetworkService.self)
            MetObjectsView(objectsViewModel: ObjectsViewModel(networkService: metService))
        case .musicCatalog:
            // Resolve the MusicCatalogServiceProtocol from the container.
            let musicService = DependencyContainer.shared.resolve(MusicCatalogServiceProtocol.self)
            MusicCatalogView(viewModel: MusicCatalogViewModel(musicCatalogService: musicService))
        default:
            Text("Empty")
        }
    }
}
