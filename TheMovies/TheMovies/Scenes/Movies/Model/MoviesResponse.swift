import Foundation

struct MoviesResponse: Decodable {
  let page: Int
  let totalPages: Int
  let totalResults: Int
  let results: [MovieResponse]
  
  enum CodingKeys: String, CodingKey {
    case page
    case results
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
}
