import Foundation

@Observable
class MovieDetailViewModel {
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
}
