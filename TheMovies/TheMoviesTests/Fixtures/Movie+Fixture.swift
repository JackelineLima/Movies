import XCTest

@testable import TheMovies

extension MovieResponse {
  static func fixture(
    id: Int = 0,
    title: String = "",
    genres: [MovieGenreResponse]? = nil,
    genreIds: [Int]? = nil,
    overview: String = "",
    releaseDate: String? = nil,
    runtime: Int? = nil,
    voteAverage: Double = 0.0,
    backdropPath: String? = nil,
    posterPath: String? = nil
  ) -> Self {
    .init(
      id: id,
      title: title,
      genres: genres,
      genreIds: genreIds,
      overview: overview,
      releaseDate: releaseDate,
      runtime: runtime,
      voteAverage: voteAverage,
      backdropPath: backdropPath,
      posterPath: posterPath)
  }
}
