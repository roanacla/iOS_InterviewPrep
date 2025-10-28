import SwiftUI

struct MovieSearchView: View {
    @State var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            List(viewModel.search.movies, id: \.imdbID) { movie in
                NavigationLink(value: movie) {
                    HStack {
                        AsyncImage(url: URL(string: movie.poster)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 120)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.year)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationDestination(for: Movie.self) { movie in
                let viewModel = MovieDetailViewModel(movie: movie)
                MovieDetailView(viewModel: viewModel)
            }
            .navigationTitle("Movies")
            .searchable(text: $viewModel.searchText)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.fetchSearch()
                }
            }
            .alert(
                viewModel.errorText,
                isPresented: $viewModel.showAlert
            ) {
                Button("OK") {
                    // Handle the acknowledgement.
                }
            }
            Text("Results: \(viewModel.search.movies.count)")
        }
        .task {
            await viewModel.fetchSearch()
        }
    }
}

#Preview {
    NavigationStack {
        MovieSearchView(viewModel: SearchViewModel())        
    }
}
