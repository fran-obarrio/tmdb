

import Foundation

enum NetworkError: Error, LocalizedError {
    case urlError
    case dataError
    case decodingError
    case dataNotAvailable
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .dataError:
            return "Server responded with an error."
        case .urlError:
            return "urlError"
        case .decodingError:
            return "decodingError"
        case .dataNotAvailable:
            return "dataNotAvailable"
        case .invalidURL:
            return "invalidURL"
        }
        
    }
}

enum MovieType {
    case nowPlaying
    case upcoming
    case topRated
    case featured
}

class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let bearerToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NjNhZWRhZWNhOTk3YjJhMmU0YWI4MmJjNTYwYjM4MyIsIm5iZiI6MTcyNjIzNDM1MC4zODYxNCwic3ViIjoiNjZlNDNkZDkyODA0OGQ5MmRlZjk3YThlIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.0X0QQE5acBGzs_ilLQW5EEUkAvXFopF6c8nh-oOunmY"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // Base URLs for different movie types
    private let baseURLNowPlaying = "https://api.themoviedb.org/3/movie/now_playing"
    private let baseURLUpcoming = "https://api.themoviedb.org/3/movie/upcoming"
    private let baseURLTopRated = "https://api.themoviedb.org/3/movie/top_rated"
    private let baseURLFeatured = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&sort_by=popularity.desc&with_release_type=2|3"
    
    // Function to fetch movies
    func fetchMovies(type: MovieType, page: Int, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        let urlString: String
        
        switch type {
        case .nowPlaying:
            urlString = "\(baseURLNowPlaying)?page=\(page)"
        case .upcoming:
            urlString = "\(baseURLUpcoming)?page=\(page)"
        case .topRated:
            urlString = "\(baseURLTopRated)?page=\(page)"
        case .featured:
            urlString = "\(baseURLFeatured)&page=\(page)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        // Create a URLRequest and add the bearer token
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?language=en-US"
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        // Create a URLRequest and add the bearer token
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(.success(movieDetail))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
}
