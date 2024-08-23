import UIKit

final class MoviesViewController: UIViewController {
  
  private lazy var segmentedControl: UISegmentedControl = {
    let control = UISegmentedControl(items: ["Upcoming", "Popular"])
    control.selectedSegmentIndex = 0
    control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    return control
  }()
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let spacing: CGFloat = 6
    let totalSpacing = spacing * 2
    let width = (UIScreen.main.bounds.width - totalSpacing) / 3
    layout.itemSize = CGSize(width: width, height: width * 1.5)
    layout.minimumInteritemSpacing = spacing
    layout.minimumLineSpacing = spacing
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  
  let service: MoviesServiceProtocol = MoviesService()
  
  var upcomingMovies: [Movie] = [Movie(title: "Teste", imageName: ""),
                                 Movie(title: "Teste2", imageName: ""),
                                 Movie(title: "Teste3", imageName: ""),
                                 Movie(title: "Teste4", imageName: "")]
  
  var popularMovies: [Movie] = [Movie(title: "Teste 2", imageName: "")]
  var currentMovies: [Movie] {
    return segmentedControl.selectedSegmentIndex == 0 ? upcomingMovies : popularMovies
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
    
    getPopularMovies()
  }
  
  private func setupViews() {
    view.addSubview(segmentedControl)
    view.addSubview(collectionView)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      
      collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func getPopularMovies() {
    service.getPopularMovies(page: 1) {[weak self] result in
      switch result {
      case .success(let popularMovies):
        print(popularMovies)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  @objc private func segmentChanged() {
    collectionView.reloadData()
  }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentMovies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
    let movie = currentMovies[indexPath.item]
    cell.configure(with: movie)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = currentMovies[indexPath.item]
    let detailVC = MovieDetailViewController(movie: movie)
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
