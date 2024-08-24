import UIKit

enum MoviesFactory {
  static func make() -> UIViewController {
    let viewModel = MoviesViewModel()
    let viewController = MoviesViewController(viewModel: viewModel)
    
    viewModel.delegate = viewController
    return viewController
  }
}
