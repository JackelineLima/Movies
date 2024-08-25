import UIKit

protocol MoviesCoordinating {
  func goToMovieDetails(with movie: MovieResponse)
}

class MoviesCoordinator: MoviesCoordinating {
  weak var viewController: UIViewController?
  
  func goToMovieDetails(with movie: MovieResponse) {
    let controller = MovieDetailsFactory.make(movie: movie)
    viewController?.navigationController?.pushViewController(controller, animated: true)
  }
}
