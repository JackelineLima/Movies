import Foundation

enum MovieDetailsEndpoint {
  case getMovie(id: Int)
}

extension MovieDetailsEndpoint: Endpoint {
  var path: String {
    switch self {
    case .getMovie(let id):
      return "/movie/\(id)"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .getMovie:
      return .get
    }
  }
}
