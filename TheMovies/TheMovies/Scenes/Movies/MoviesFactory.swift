import UIKit

enum MoviesFactory {
  static func make() -> UIViewController {
    let coordinator = MoviesCoordinator()
    let viewModel = MoviesViewModel(coordinator: coordinator)
    let viewController = MoviesViewController(viewModel: viewModel)
    
    viewModel.delegate = viewController
    coordinator.viewController = viewController
    return viewController
  }
}
