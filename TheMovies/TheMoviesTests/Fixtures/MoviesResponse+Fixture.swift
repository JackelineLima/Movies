import XCTest

@testable import TheMovies

extension MoviesResponse {
  static func fixture(
    page: Int = 0,
    totalPages: Int = 0,
    totalResults: Int = 0,
    results: [MovieResponse] = []
  ) -> Self {
    .init(
      page: page,
      totalPages: totalPages,
      totalResults: totalResults,
      results: results
    )
  }
}

