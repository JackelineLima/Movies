import UIKit

final class MoviesHeaderView: UICollectionReusableView {
  static let identifier = "MoviesHeaderView"
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textColor = .white
    label.textAlignment = .left
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
  
  func configure(with title: String) {
    titleLabel.text = title
  }
}

private extension MoviesHeaderView {
  func configureViews() {
    addSubviews(titleLabel)
  }
  
  func configureConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.topAnchor.constraint(equalTo: topAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}
