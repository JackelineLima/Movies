import XCTest

@testable import TheMovies

final class MoviesViewModelDelegateSpy: MoviesViewDisplay {
  private(set) var showPaginationLoadingCalled = false
  func showPaginationLoading() {
    showPaginationLoadingCalled = true
  }
  
  private(set) var showLoadingCalled = false
  func showLoading() {
    showLoadingCalled = true
  }
  
  private(set) var hideLoadingCalled = false
  func hideLoading() {
    hideLoadingCalled = true
  }
  
  private(set) var reloadDataCalled = false
  func reloadData() {
    reloadDataCalled = true
  }
  
  private(set) var didFailCalled = false
  private(set) var didFailErrorPassed: ErrorHandler?
  func didFail(with error: ErrorHandler) {
    didFailCalled = true
    didFailErrorPassed = error
  }
}

final class MoviesCoordinatorSpy: MoviesCoordinating {
  private(set) var goToMovieDetailsCalled = false
  private(set) var goToMovieDetailsPassed: MovieResponse?
  func goToMovieDetails(with movie: MovieResponse) {
    goToMovieDetailsCalled = true
    goToMovieDetailsPassed = movie
  }
}

final class ListPopularMoviesViewModelTests: XCTestCase {
  private let serviceSpy = MoviesServiceSpy()
  private let delegateSpy = MoviesViewModelDelegateSpy()
  private let coordinatorSpy = MoviesCoordinatorSpy()
  private lazy var sut = MoviesViewModel(
    service: serviceSpy, 
    coordinator: coordinatorSpy
  )
  
  func test_getMovieAtIndexPath_shouldReturnMovie() {
    // Given
    serviceSpy.getPopularMoviesReturned = .fixture(
      results: [
        MovieResponse.fixture(posterPath: "/image1.jpg"),
        MovieResponse.fixture(posterPath: "/image2.jpg"),
        MovieResponse.fixture(posterPath: "/image3.jpg")
      ]
    )
    
    // When
    sut.loadPopularMovies()
    let movie = sut.getMovie(at: IndexPath.init(row: 2, section: 1))
    
    // Then
    XCTAssertEqual(movie, MovieResponse.fixture(posterPath: "/image3.jpg"))
  }
  
  func test_numberofRow_shouldReturnDataSourceCount() {
    // Given
    serviceSpy.getPopularMoviesReturned = .fixture(
      results: [
        MovieResponse.fixture(),
        MovieResponse.fixture(),
        MovieResponse.fixture(),
        MovieResponse.fixture(),
        MovieResponse.fixture(),
        MovieResponse.fixture(),
        MovieResponse.fixture(),
        MovieResponse.fixture(),
        MovieResponse.fixture()
      ]
    )
    
    // When
    sut.loadPopularMovies()
    let numberOfRows = sut.numberOfRows()
    
    // Then
    XCTAssertEqual(numberOfRows, 9)
  }
  
  func test_didSelectRowAtIndexPath_shouldNavigateToDetails_usingCoordinator() {
    // Given
    serviceSpy.getPopularMoviesReturned = .fixture(
      results: [
        MovieResponse.fixture(id: 23),
        MovieResponse.fixture(id: 45),
        MovieResponse.fixture(id: 67),
        MovieResponse.fixture(id: 33)
      ]
    )
    
    // When
    sut.loadPopularMovies()
    sut.didSelectItem(at: IndexPath.init(row: 2, section: 1))
    
    // Then
    XCTAssertTrue(coordinatorSpy.goToMovieDetailsCalled)
    XCTAssertEqual(coordinatorSpy.goToMovieDetailsPassed?.id, 67)
  }
  
  func test_loadPopularMovies_firstCall_shouldShowLoading_and_sendPageOneToService() {
    // Given
    let page = 1
    sut.delegate = delegateSpy
    
    // When
    sut.loadPopularMovies()
    
    // Then
    XCTAssertTrue(delegateSpy.showLoadingCalled)
    XCTAssertEqual(page, serviceSpy.getPopularMoviesPagePassed)
  }
  
  func test_userRequestedMoreData_shouldCallService_oneTime() {
    // Given
    let callCount = 1
    sut.delegate = delegateSpy
    
    // When
    sut.userRequestedMoreData()
    
    // Then
    XCTAssertTrue(delegateSpy.showPaginationLoadingCalled)
    XCTAssertEqual(serviceSpy.getPopularMoviesCalled, callCount)
  }
  
  func test_userRequestedMoreData_shouldShowLoading_and_callService() {
    // Given
    let callCount = 1
    sut.delegate = delegateSpy
    
    // When
    sut.userRequestedMoreData()
    
    // Then
    XCTAssertTrue(delegateSpy.showPaginationLoadingCalled)
    XCTAssertEqual(serviceSpy.getPopularMoviesCalled, callCount)
  }
  
  func test_getPopularMovies_firstCall_shouldPaginate_toPageTwo() {
    // Given
    let page = 2
    let callCount = 2
    serviceSpy.getPopularMoviesReturned = .fixture(page: 1)
    sut.delegate = delegateSpy
    sut.loadPopularMovies()
    
    // When
    sut.userRequestedMoreData()
    
    // Then
    XCTAssertTrue(delegateSpy.reloadDataCalled)
    XCTAssertEqual(serviceSpy.getPopularMoviesPagePassed, page)
    XCTAssertEqual(serviceSpy.getPopularMoviesCalled, callCount)
    XCTAssertTrue(delegateSpy.hideLoadingCalled)
  }
}
