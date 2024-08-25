import UIKit

protocol MovieDetailsViewDisplay: AnyObject {
  func showLoading()
  func hideLoading()
  func didLoadMovieDetails()
  func didFail(with error: ErrorHandler)
}

final class MovieDetailsViewController: UIViewController {
  private var viewModel: MovieDetailsViewModelProtocol
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .black
    return scrollView
  }()
  
  private let imgView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 28)
    label.numberOfLines = 0
    label.textColor = .white
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .white
    return label
  }()
  
  private let overviewLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .white
    return label
  }()
  
  private let ratingLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .white
    return label
  }()
  
  private let scoreLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .white
    return label
  }()
  
  init(viewModel: MovieDetailsViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    configureConstraints()
    configureNavigationBar()
    loadData()
  }
  
  private func configureViews() {
    view.backgroundColor = .black
    view.addSubviews(scrollView)
    scrollView.addSubviews(
      imgView,
      titleLabel,
      subtitleLabel,
      overviewLabel,
      ratingLabel,
      scoreLabel
    )
  }
  
  private func configureConstraints() {
    let aspectRatio: CGFloat = 16 / 9
    
    let imageWidth: CGFloat = view.frame.size.width
    let imageHeight: CGFloat = imageWidth / aspectRatio
    let padding: CGFloat = 12
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      imgView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      imgView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      imgView.heightAnchor.constraint(equalToConstant: imageHeight),
      imgView.widthAnchor.constraint(equalToConstant: imageWidth),
      
      titleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: -padding),
      
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
      subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      
      overviewLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: padding),
      overviewLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
      overviewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      
      ratingLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: padding),
      ratingLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
      
      scoreLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: padding),
      scoreLabel.topAnchor.constraint(equalTo: ratingLabel.topAnchor),
      scoreLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding)
    ])
  }
  
  private func loadData() {
    viewModel.getMovie()
  }
}

private extension MovieDetailsViewController {
  func updateView() {
    imgView.loadImage(
      from: viewModel.backdropImageURL,
      placeholder: UIImage(named: Constants.Images.backdropPlaceholder)
    )
    titleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    overviewLabel.text = viewModel.overview
    ratingLabel.text = viewModel.ratingStars
    scoreLabel.text = viewModel.score
  }
  
  func configureNavigationBar() {
    navigationController?.navigationBar.tintColor = .white
  }
}

extension MovieDetailsViewController: MovieDetailsViewDisplay, Loadable, Alertable {
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
    }
  }
  
  func didLoadMovieDetails() {
    DispatchQueue.main.async { [weak self] in
      self?.updateView()
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
