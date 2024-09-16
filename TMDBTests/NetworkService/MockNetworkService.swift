
import Foundation

class MockNetworkService: NetworkServiceProtocol {    
    
    var characterResult: Result<[Movie], NetworkError>?
    
    func fetchMovies(type: MovieType, page: Int, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        if let result = characterResult {
            completion(result)
        } else {
            completion(.failure(.dataNotAvailable))
        }
    }

}
