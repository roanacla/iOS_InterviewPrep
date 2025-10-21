import SwiftUI

// Create a simple view in Swift named Concepts
struct ConceptsView: View {
    let viewModel: ConceptsViewModel
    let networkingViewModel: NetworkingViewModel
    
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
//                case .networking:
//                    NetworkingView(concept: concept, viewModel: networkingViewModel)
                case .conectedFour:
                    ConectedFourView()
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
        ConceptsView(viewModel: .init(), networkingViewModel: .init(songDownloader: .init()))
    }
}
