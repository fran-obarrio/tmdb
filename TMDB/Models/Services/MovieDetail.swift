import Foundation

struct MovieDetail: Codable {
    let title: String
    let overview: String
    let releaseDate: String
    let runtime: Int
    let voteAverage: Double
    let genres: [Genre]
    let posterPath: String?
    let backdropPath: String?
    let tagline: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case genres
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case tagline
        case status
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
