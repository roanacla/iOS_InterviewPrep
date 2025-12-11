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
            let musicCatalogViewModel = DependencyContainer.shared.resolve(MusicCatalogViewModel.self)
            MusicCatalogView(viewModel: musicCatalogViewModel)
        default:
            Text("Empty")
        }
    }
}
