import Foundation

struct MovieResponse: Decodable {
  let id: Int
  let title: String
  let genres: [MovieGenreResponse]?
  let genreIds: [Int]?
  let overview: String
  let releaseDate: String?
  let runtime: Int?
  let voteAverage: Double
  let backdropPath: String?
  let posterPath: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case genres
    case genreIds = "genre_ids"
    case overview
    case releaseDate = "release_date"
    case runtime
    case voteAverage = "vote_average"
    case backdropPath = "backdrop_path"
    case posterPath = "poster_path"
  }
}

extension MovieResponse: Equatable {
    static func == (lhs: MovieResponse, rhs: MovieResponse) -> Bool {
        return true
    }
}
