import XCTest

@testable import TheMovies

final class MoviesServiceSpy: MoviesServiceProtocol {
  var getPopularMoviesReturned: MoviesResponse?
  private(set) var getPopularMoviesPagePassed = 0
  private(set) var getPopularMoviesCalled: Int = 0
  
  private(set) var getMovieIdPassed: Int?
  
  func getPopularMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void) {
    getPopularMoviesPagePassed = page
    getPopularMoviesCalled += 1
    guard let getMovieToBeReturned = getPopularMoviesReturned else {
      return completion(.failure(ErrorHandler.noResponse))
    }
    
    return completion(.success(getMovieToBeReturned))
  }
}
