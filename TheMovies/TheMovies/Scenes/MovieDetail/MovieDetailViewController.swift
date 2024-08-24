import UIKit

final class MovieDetailViewController: UIViewController {
  
  private let movie: MovieResponse
  
  init(movie: MovieResponse) {
    self.movie = movie
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = movie.title
  }
}
