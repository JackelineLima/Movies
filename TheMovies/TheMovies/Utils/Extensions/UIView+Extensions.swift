import UIKit

extension UIView {
  func addSubviews(_ view: UIView...) {
    view.forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview($0)
    }
  }
}
