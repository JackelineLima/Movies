import UIKit

protocol Alertable: UIViewController {
  func showActionAlert(message: String, action: @escaping () -> Void)
  func showConfirmationAlert(message: String)
}

extension Alertable {
  func showActionAlert(message: String, action: @escaping () -> Void) {
    let alert = UIAlertController(title: Constants.Alerts.defaultTitle, message: message, preferredStyle: .alert)
    alert.addAction(
      UIAlertAction(title: Constants.Alerts.tryAgainButtonText, style: .default) { _ in
        action()
      }
    )
    alert.addAction(
      UIAlertAction(title: Constants.Alerts.defaultButtonText, style: .cancel) { [weak self] _ in
        self?.dismiss(animated: true)
      }
    )
    present(alert, animated: true, completion: nil)
  }
  
  func showConfirmationAlert(message: String) {
    let confirm = UIAlertController(title: Constants.Alerts.defaultTitle, message: message, preferredStyle: .alert)
    confirm.addAction(UIAlertAction(title: Constants.Alerts.defaultButtonText, style: .cancel))
    present(confirm, animated: true, completion: nil)
  }
}
