//
//  TMDBTests.swift
//  TMDBTests
//
//  Created by Francisco Obarrio on 15/09/2024.
//

import XCTest
@testable import TMDB

class MovieListViewModelTests: XCTestCase {
    
    var viewModel: MovieListViewModel!
    var mockService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        viewModel = MovieListViewModel(networkService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    // Test: Fetch Featured Movies Success
    func testFetchFeaturedMoviesSuccess() {
        // Given
        let expectedMovie = Movie(
            id: 1,
            title: "Deadpool & Wolverine",
            originalTitle: "Deadpool & Wolverine",
            overview: "Test movie",
            releaseDate: "2024-07-24",
            voteAverage: 7.5,
            voteCount: 200,
            posterPath: "/path_to_poster.jpg",
            backdropPath: "/path_to_backdrop.jpg",
            adult: false,
            genreIds: [28, 35],
            popularity: 2392.159,
            video: false,
            originalLanguage: "en",
            isFavorite: false
        )
        
        mockService.characterResult = Result<[Movie], NetworkError>.success([expectedMovie])
        
        // When
        viewModel.fetchMovies(type: .featured, page: 1) { result in
            // Then
            XCTAssertEqual(self.viewModel.featuredMovies.count, 1)
            XCTAssertEqual(self.viewModel.featuredMovies.first?.title, "Deadpool & Wolverine")
        }
    }
    
    // Test: Fetch Now Playing Movies Success
    func testFetchNowPlayingMoviesSuccess() {
        // Given
        let expectedMovie = Movie(
            id: 1,
            title: "Deadpool & Wolverine",
            originalTitle: "Deadpool & Wolverine",
            overview: "Test movie",
            releaseDate: "2024-07-24",
            voteAverage: 7.5,
            voteCount: 200,
            posterPath: "/path_to_poster.jpg",
            backdropPath: "/path_to_backdrop.jpg",
            adult: false,
            genreIds: [28, 35],
            popularity: 2392.159,
            video: false,
            originalLanguage: "en",
            isFavorite: false
        )
        
        mockService.characterResult = Result<[Movie], NetworkError>.success([expectedMovie])
        
        // When
        viewModel.fetchMovies(type: .nowPlaying, page: 1) { result in
            // Then
            XCTAssertEqual(self.viewModel.bottomMovies.count, 1)
            XCTAssertEqual(self.viewModel.bottomMovies.first?.title, "Deadpool & Wolverine")
        }
    }
    
    // Test: Fetch Top Rated Movies Success
    func testFetchTopRatedMoviesSuccess() {
        // Given
        let expectedMovie = Movie(
            id: 2,
            title: "Avengers: Endgame",
            originalTitle: "Avengers: Endgame",
            overview: "Test top-rated movie",
            releaseDate: "2019-04-24",
            voteAverage: 8.4,
            voteCount: 10000,
            posterPath: "/path_to_poster.jpg",
            backdropPath: "/path_to_backdrop.jpg",
            adult: false,
            genreIds: [28, 12],
            popularity: 5000.123,
            video: false,
            originalLanguage: "en",
            isFavorite: false
        )
        
        mockService.characterResult = Result<[Movie], NetworkError>.success([expectedMovie])
        
        // When
        viewModel.fetchMovies(type: .topRated, page: 1) { result in
            // Then
            XCTAssertEqual(self.viewModel.bottomMovies.count, 1)
            XCTAssertEqual(self.viewModel.bottomMovies.first?.title, "Avengers: Endgame")
        }
    }
    
    // Test: Fetch Movies With No Results
    func testFetchMoviesNoResults() {
        // Given
        mockService.characterResult = Result<[Movie], NetworkError>.success([])
        
        // When
        viewModel.fetchMovies(type: .nowPlaying, page: 1) { result in
            // Then
            XCTAssertEqual(self.viewModel.bottomMovies.count, 0)
        }
    }
    
    
    // Test: Fetch Movies Failure (DataError)
    func testFetchMoviesFailure() {
        // Given
        mockService.characterResult = Result<[Movie], NetworkError>.failure(.dataError)
        
        // When
        viewModel.fetchMovies(type: .nowPlaying, page: 1) { result in
            // Then
            XCTAssertEqual(self.viewModel.bottomMovies.count, 0)
        }
    }
    
    // Test: Decoding Error Handling
    func testDecodingErrorHandling() {
        // Given
        mockService.characterResult = Result<[Movie], NetworkError>.failure(.decodingError)
        // When
        viewModel.fetchMovies(type: .nowPlaying, page: 1) { result in
            // Then
            XCTAssertEqual(self.viewModel.featuredMovies.count, 0)
        }
    }
}
