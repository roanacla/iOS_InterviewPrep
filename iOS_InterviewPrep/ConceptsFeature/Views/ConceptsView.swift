import SwiftUI

// Create a simple view in Swift named Concepts
struct ConceptsView: View {
    let viewModel: ConceptsViewModel
    
    var body : some View {
        NavigationStack {
            List(viewModel.concepts) { concept in
                NavigationLink(value: concept) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(concept.title)
                            .font(.headline)
                        Text(concept.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Concepts")
            .navigationDestination(for: Concept.self) { concept in
                switch concept.subject {
                case .conectedFour:
                    ConectedFourView()
                case .searchMovies:
                    MovieSearchView(viewModel: SearchViewModel())
                case .metMuseum:
                    MetObjectsView(objectsViewModel: ObjectsViewModel(networkService: MetNetworkService()))
                case .musicCatalog:
                    MusicCatalogView(viewModel: MusicCatalogViewModel())
                default:
                    Text("Empty")
                }
            }
        }
    }
}

//Preview
struct Concepts_Previews: PreviewProvider {
    static var previews: some View {
        ConceptsView(viewModel: .init())
    }
}
