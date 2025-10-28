import SwiftUI

struct MovieDetailView: View {
    @State var viewModel: MovieDetailViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.movie.poster)) { image in
                image
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
                    .shadow(radius: 2)
            } placeholder: {
                ProgressView()
            }
            Text(viewModel.movie.title)
                .font(.headline)
            Text(viewModel.movie.year)
                .font(.subheadline)
        }
        .task {
            viewModel.movie.title += "✅"
        }
    }
}

#Preview {
    MovieDetailView(viewModel: MovieDetailViewModel(movie: Movie(title: "Test", year: "1992", imdbID: "as;dlfkjasdf", poster: "a;sldfkjasf")))
}
