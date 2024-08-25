import UIKit

final class MovieCell: UICollectionViewCell {
  
  private let movieImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.textAlignment = .center
    label.numberOfLines = 2
    label.textColor = .white
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.textAlignment = .center
    label.textColor = .white
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
    configureConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(with model: MovieResponse) {
    let viewModel = MoviesCellViewModel(movie: model)
    movieImage.loadImage(
      from: viewModel.posterImageURL,
      placeholder: UIImage(named: Constants.Images.posterPlaceholder)
    )
    dateLabel.text = model.releaseDate?.toBrazilianDateFormat()
    titleLabel.text = model.title
  }
}

private extension MovieCell {
  func configureViews() {
    contentView.addSubviews(
      movieImage,
      titleLabel,
      dateLabel
    )
  }
  
  func configureConstraints() {
    NSLayoutConstraint.activate([
      movieImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      movieImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.85),
      
      dateLabel.leadingAnchor.constraint(equalTo: movieImage.leadingAnchor, constant: 4),
      dateLabel.trailingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: -4),
      dateLabel.bottomAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: -4),
      
      titleLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
    ])
  }
}
