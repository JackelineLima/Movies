import Foundation

protocol MoviesServiceProtocol {
    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void)
}

final class MoviesService: MoviesServiceProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
        self.httpClient = httpClient
    }

    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void) {
        httpClient.request(
            endpoint: MoviesEndpoint.getPopularMovies(page: page),
            model: MoviesResponse.self,
            completion: completion
        )
    }
}

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

import Foundation

struct MovieResponse: Decodable {
    let id: Int
    let title: String
    let genres: [MovieGenre]?
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

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return true
    }
}

import Foundation

struct MovieGenre: Decodable {
    let id: Int
    let name: String
}

enum MovieGenres: Int, CaseIterable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37

    var description: String {
        switch self {
        case .action: return "Action"
        case .adventure: return "Adventure"
        case .animation: return "Animation"
        case .comedy: return "Comedy"
        case .crime: return "Crime"
        case .documentary: return "Documentary"
        case .drama: return "Drama"
        case .family: return "Family"
        case .fantasy: return "Fantasy"
        case .history: return "History"
        case .horror: return "Horror"
        case .music: return "Music"
        case .mystery: return "Mystery"
        case .romance: return "Romance"
        case .scienceFiction: return "Science Fiction"
        case .tvMovie: return "TV Movie"
        case .thriller: return "Thriller"
        case .war: return "War"
        case .western: return "Western"
        }
    }
}



