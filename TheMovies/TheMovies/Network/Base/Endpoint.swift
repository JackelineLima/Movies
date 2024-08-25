import Foundation

protocol Endpoint {
    var path: String { get }
    var body: [String: Any]? { get }
    var header: [String: String] { get }
    var method: HTTPMethod { get }
    var queryParams: [URLQueryItem] { get }
    var timeout: TimeInterval { get }
    var completeURL: URL? { get }
}

extension Endpoint {
    var body: [String: Any]? {
        return nil
    }

    var header: [String: String] {
        let apiKey = getAuthInfoFromPropertyList()

        return [
            "Authorization": "Bearer \(apiKey)"
        ]
    }

    var queryParams: [URLQueryItem] {
        return []
    }

    var timeout: TimeInterval {
        return 30
    }

    var completeURL: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3" + path
        urlComponents.queryItems = queryParams

        return urlComponents.url
    }
  
  private func getAuthInfoFromPropertyList() -> String {
      let fileName = "TMDB-Auth-Info"
      let propertyKey = "TMDB_API_KEY"

      guard let filePath = Bundle.main.path(forResource: fileName, ofType: "plist") else {
          fatalError("Couldn't find file '\(fileName).plist' on target root directory.")
      }
      guard let value = NSDictionary(contentsOfFile: filePath)?.object(forKey: propertyKey) as? String else {
          fatalError("Couldn't find key '\(propertyKey)' in '\(fileName).plist'.")
      }

      return value
  }
}
