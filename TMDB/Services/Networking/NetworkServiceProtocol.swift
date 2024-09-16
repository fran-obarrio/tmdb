

protocol NetworkServiceProtocol {
    
    func fetchMovies(type: MovieType, page: Int, completion: @escaping (Result<[Movie], NetworkError>) -> Void)
    
    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetail, NetworkError>) -> Void)
}
