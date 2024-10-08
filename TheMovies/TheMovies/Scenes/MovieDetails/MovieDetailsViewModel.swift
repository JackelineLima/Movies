import Foundation

protocol MovieDetailsViewModelProtocol {
  func getMovie()
  var backdropImageURL: String { get }
  var title: String { get }
  var primaryGenre: String { get }
  var subtitle: String { get }
  var overview: String { get }
  var score: String  { get }
  var ratingStars: String { get }
}

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
  private var movie: MovieResponse
  private var service: MovieDetailsServiceProtocol
  weak var delegate: MovieDetailsViewDisplay?
  
  init(
    service: MovieDetailsServiceProtocol = MovieDetailsService(),
    movie: MovieResponse
  ) {
    self.service = service
    self.movie = movie
  }
  
  var id: Int {
    return movie.id
  }
  
  var backdropImageURL: String {
    guard let posterPath = movie.backdropPath else {
      return Constants.ImageURL.backdropPlaceholder
    }
    return Constants.ImageURL.highQuality + posterPath
  }
  
  var title: String {
    return movie.title
  }
  
  var primaryGenre: String {
    guard let primaryGenre = movie.genres?.first?.name else {
      return Constants.notAvailable
    }
    return primaryGenre
  }
  
  var subtitle: String {
    guard
      let runtime = movie.runtime, runtime > 0,
      let duration = convertMinutesToHoursAndMinutes(runtime: runtime),
      let releaseDate = movie.releaseDate,
      let releaseYear = getYearComponentOfDate(date: releaseDate)
    else {
      return Constants.notAvailable
    }
    
    return "\(primaryGenre) • \(releaseYear) • \(duration)"
  }
  
  var overview: String {
    return movie.overview
  }
  
  var ratingStars: String {
    let truncatedRating = Int(movie.voteAverage)
    let ratingStars = (0 ..< truncatedRating).reduce("") { partialResult, _ -> String in
      return partialResult + "★"
    }
    return ratingStars
  }
  
  var score: String {
    let hasScore = movie.voteAverage > 0
    let truncatedScore = String(format: "%.1f", movie.voteAverage)
    
    return hasScore ? "\(truncatedScore)/10" : String()
  }
  
  func getMovie() {
    delegate?.showLoading()
    service.getMovie(id: movie.id) { [weak self] result in
      switch result {
      case .success(let movie):
        self?.movie = movie
        self?.delegate?.didLoadMovieDetails()
        self?.delegate?.hideLoading()
      case .failure(let error):
        self?.delegate?.didFail(with: error)
      }
    }
  }
}

extension MovieDetailsViewModel {
  func convertMinutesToHoursAndMinutes(runtime: Int) -> String? {
    let dateComponentesFormatter = DateComponentsFormatter()
    dateComponentesFormatter.unitsStyle = .full
    dateComponentesFormatter.calendar?.locale = Locale(identifier: "en-US")
    dateComponentesFormatter.allowedUnits = [.hour, .minute]
    
    let hoursAndMinutes = dateComponentesFormatter.string(
      from: TimeInterval(runtime) * 60
    )
    
    return hoursAndMinutes
  }
  
  func getYearComponentOfDate(date: String) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    guard let date = formatter.date(from: date) else {
      return nil
    }
    formatter.dateFormat = "yyyy"
    let yearOfRelease = formatter.string(from: date)
    
    return yearOfRelease
  }
}
