import UIKit

enum MovieDetailsFactory {
  static func make(movie: MovieResponse) -> UIViewController {
    let viewModel = MovieDetailsViewModel(movie: movie)
    let viewController = MovieDetailsViewController(viewModel: viewModel)
    
    viewModel.delegate = viewController
    return viewController
  }
}
