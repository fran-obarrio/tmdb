
class MovieListViewModel {
    private var networkService: NetworkServiceProtocol
    
    var featuredMovies: [Movie] = []
    var bottomMovies: [Movie] = []
    var movieDetail: MovieDetail?    

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchMovies(type: MovieType, page: Int, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        networkService.fetchMovies(type: type, page: page) { result in
            switch result {
            case .success(let movies):
                if type == .featured {
                    self.featuredMovies = movies
                } else {
                    self.bottomMovies = movies
                }
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void) {
           networkService.fetchMovieDetail(movieId: movieId) { result in
               switch result {
               case .success(let movieDetail):
                   self.movieDetail = movieDetail
                   completion(.success(movieDetail))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
}
