import UIKit

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
  private static var imageURLKey = "imageURLKey"
  
  private var imageURL: URL? {
    get {
      return objc_getAssociatedObject(self, &UIImageView.imageURLKey) as? URL
    }
    set {
      objc_setAssociatedObject(self, &UIImageView.imageURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  private func getData(from url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) {
    URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
  }
  
  func loadImage(from stringURL: String, placeholder: UIImage? = nil) {
    guard let url = URL(string: stringURL) else { return }
    
    self.imageURL = url
    self.image = placeholder
    
    if let cachedImage = imageCache.object(forKey: NSString(string: url.absoluteString)) {
      self.image = cachedImage
      return
    }
    
    getData(from: url) { [weak self] data, _, _ in
      guard let self = self else { return }
      
      let image: UIImage? = {
        if let data = data, let downloadedImage = UIImage(data: data) {
          imageCache.setObject(downloadedImage, forKey: NSString(string: url.absoluteString))
          return downloadedImage
        }
        return placeholder
      }()
      
      DispatchQueue.main.async {
        if self.imageURL == url {
          self.image = image
        }
      }
    }
  }
}
