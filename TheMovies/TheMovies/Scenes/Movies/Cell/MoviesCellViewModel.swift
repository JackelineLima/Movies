import Foundation

struct MoviesCellViewModel {
  private let movie: MovieResponse
  
  init(movie: MovieResponse) {
    self.movie = movie
  }
  
  var posterImageURL: String {
    guard let posterPath = movie.posterPath else {
      return Constants.ImageURL.posterPlaceholder
    }
    return Constants.ImageURL.highQuality + posterPath
  }
}
