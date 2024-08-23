import UIKit

final class MovieCell: UICollectionViewCell {
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    contentView.backgroundColor = .red
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
      
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
  
  func configure(with movie: Movie) {
    imageView.image = UIImage(named: movie.imageName)
    titleLabel.text = movie.title
  }
}
