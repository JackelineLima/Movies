import XCTest

@testable import TheMovies

final class MovieDetailsServiceSpy: MovieDetailsServiceProtocol {
  var getMovieToBeReturned: MovieResponse?
  private(set) var getMovieCalled = false
  private(set) var getMovieCount: Int = 0
  private(set) var getMovieIdPassed: Int?
  
  func getMovie(id: Int, completion: @escaping (Result<MovieResponse, ErrorHandler>) -> Void) {
    getMovieCalled = true
    getMovieCount += 1
    getMovieIdPassed = id
    
    guard let getMovieToBeReturned = getMovieToBeReturned else {
      return completion(.failure(ErrorHandler.noResponse))
    }
    
    return completion(.success(getMovieToBeReturned))
  }
}
