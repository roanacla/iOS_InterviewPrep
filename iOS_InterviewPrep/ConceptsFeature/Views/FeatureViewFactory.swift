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
            MetObjectsView(objectsViewModel: ObjectsViewModel(networkService: MetNetworkService()))
        case .musicCatalog:
            MusicCatalogView(viewModel: MusicCatalogViewModel(musicCatalogService: ITunesCatalogService()))
        default:
            Text("Empty")
        }
    }
}
