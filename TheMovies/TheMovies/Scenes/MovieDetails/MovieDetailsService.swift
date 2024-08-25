import Foundation

protocol MovieDetailsServiceProtocol {
  func getMovie(id: Int, completion: @escaping (Result<MovieResponse, ErrorHandler>) -> Void)
}

final class MovieDetailsService: MovieDetailsServiceProtocol {
  private let httpClient: HTTPClientProtocol
  
  init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
    self.httpClient = httpClient
  }
  
  func getMovie(id: Int, completion: @escaping (Result<MovieResponse, ErrorHandler>) -> Void) {
    httpClient.request(
      endpoint: MovieDetailsEndpoint.getMovie(id: id),
      model: MovieResponse.self,
      completion: completion
    )
  }
}
