import Foundation

struct TVShowResponse: Codable {
    let score: Double
    let show: TVShow
}

struct TVShow: Codable {
    let id: Int
    let name: String
    let summary: String?
    let genres: [String]?
    let rating: TVRating?
    let image: TVImage?
    let premiered: String?
    let runtime: Int?
    let status: String?
    let network: TVNetwork?
    let language: String?
    let externals: TVExternals?
}

struct TVExternals: Codable {
    let tvrage: Int?
    let thetvdb: Int?
    let imdb: String?
}

struct TVRating: Codable {
    let average: Double?
}

struct TVImage: Codable {
    let medium: String?
    let original: String?
}

struct TVNetwork: Codable {
    let name: String?
}
