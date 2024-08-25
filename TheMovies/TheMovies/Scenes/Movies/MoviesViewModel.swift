import Foundation

protocol MoviesViewModelDelegate: AnyObject {
  func loadPopularMovies()
  func numberOfRows() -> Int
  func didSelectItem(at indexPath: IndexPath)
  func userRequestedMoreData()
  func getMovie(at indexPath: IndexPath) -> MovieResponse
  func getTitle() -> String
  var selectedSegmentIndex: Int { get set }
}

final class MoviesViewModel: MoviesViewModelDelegate {
  
  weak var delegate: MoviesViewDisplay?
  private let service: MoviesServiceProtocol
  private let coordinator: MoviesCoordinating
  private var currentPage: Int = 1
  private var isLoading = false
  private var upcomingMovies: [MovieResponse] = []
  private var popularMovies: [MovieResponse] = []
  
  var selectedSegmentIndex: Int = 0 {
    didSet {
      delegate?.reloadData()
    }
  }
  
  var currentMovies: [MovieResponse] {
    return selectedSegmentIndex == 0 ? popularMovies : upcomingMovies
  }
  
  init(service: MoviesServiceProtocol = MoviesService(), coordinator: MoviesCoordinating) {
    self.service = service
    self.coordinator = coordinator
  }
  
  func getMovie(at indexPath: IndexPath) -> MovieResponse {
    return currentMovies[indexPath.row]
  }
  
  func getTitle() -> String {
    return selectedSegmentIndex == 0 ? "Popular Movies" : "Upcoming Movies"
  }
  
  func numberOfRows() -> Int {
    return currentMovies.count
  }
  
  func didSelectItem(at indexPath: IndexPath) {
    let movie = getMovie(at: indexPath)
    coordinator.goToMovieDetails(with: movie)
  }
  
  func loadPopularMovies() {
    delegate?.showLoading()
    getPopularMovies()
  }
  
  func userRequestedMoreData() {
    if !isLoading {
      delegate?.showPaginationLoading()
      getPopularMovies()
    }
  }
  
  private func getPopularMovies() {
    service.getPopularMovies(page: currentPage) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let popularMovies):
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let upcoming = popularMovies.results.filter { movie in
          guard let releaseDateString = movie.releaseDate,
                let releaseDate = dateFormatter.date(from: releaseDateString) else {
            return false
          }
          return releaseDate > today
        }
        
        self.upcomingMovies.append(contentsOf: upcoming)
        self.popularMovies.append(contentsOf: popularMovies.results)
        self.currentPage += 1
        self.delegate?.reloadData()
      case .failure(let error):
        self.delegate?.didFail(with: error)
      }
      self.isLoading = false
      self.delegate?.hideLoading()
    }
  }
}
