import UIKit

protocol MoviesViewDisplay: AnyObject {
  func reloadData()
  func showPaginationLoading()
  func showLoading()
  func hideLoading()
  func didFail(with error: ErrorHandler)
}

final class MoviesViewController: UIViewController {
  
  private lazy var segmentedControl: UISegmentedControl = {
    let control = UISegmentedControl(items: ["Popular", "Upcoming"])
    control.selectedSegmentIndex = 0
    control.selectedSegmentTintColor = .white
    control.backgroundColor = .clear
    control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    return control
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let spacing: CGFloat = 6
    let totalSpacing = spacing * 2
    let width = (UIScreen.main.bounds.width - totalSpacing) / 3
    layout.itemSize = CGSize(width: width, height: width * 1.5)
    layout.minimumInteritemSpacing = spacing
    layout.minimumLineSpacing = spacing
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
    collectionView.register(MoviesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MoviesHeaderView.identifier)
    collectionView.backgroundColor = .black.withAlphaComponent(0.5)
    return collectionView
  }()
  
  private let collectionViewFooter: UICollectionReusableView = {
    let view = UICollectionReusableView()
    return view
  }()
  
  private let viewModel: MoviesViewModelDelegate
  
  init(viewModel: MoviesViewModelDelegate) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    loadData()
  }
  
  private func setupViews() {
    view.addSubviews(segmentedControl, collectionView)
    
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
  
  @objc private func segmentChanged() {
    viewModel.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
  }
  
  private func loadData() {
    viewModel.loadPopularMovies()
  }
}

extension MoviesViewController: MoviesViewDisplay, Loadable, Alertable {
  func showLoading() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.showSpinner(on: self.view)
    }
  }
  
  func hideLoading() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.removeSpinner(on: self.view)
      self.removeSpinner(on: self.collectionViewFooter)
    }
  }
  
  func showPaginationLoading() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.showSpinner(on: self.collectionViewFooter, size: .large)
    }
  }
  
  func reloadData() {
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.reloadData()
    }
  }
  
  func didFail(with error: ErrorHandler) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.showActionAlert(
        message: error.customMessage,
        action: self.loadData
      )
    }
  }
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
    let movie = viewModel.getMovie(at: indexPath)
   
    cell.setup(with: movie)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.didSelectItem(at: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let lastSection = collectionView.numberOfSections - 1
    let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
    if indexPath.section == lastSection && indexPath.row == lastItem {
      viewModel.userRequestedMoreData()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader else {
      return UICollectionReusableView()
    }
    
    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MoviesHeaderView.identifier, for: indexPath) as? MoviesHeaderView else { return UICollectionReusableView() }
    headerView.configure(with: viewModel.getTitle())
    return headerView
  }
}

