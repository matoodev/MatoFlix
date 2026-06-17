import Foundation

class TMDBAPI {
    static let shared = TMDBAPI()
    private let base = "https://api.themoviedb.org/3"
    private let imageBase = "https://image.tmdb.org/t/p"
    private let apiKey = "your-tmdb-api-key-here"

    private let session: URLSession = {
        let c = URLSessionConfiguration.default
        c.timeoutIntervalForRequest = 15
        return URLSession(configuration: c)
    }()

    func popular(page: Int = 1, lang: String = "en-US") async throws -> [TMDBMovie] {
        let url = URL(string: "\(base)/movie/popular?api_key=\(apiKey)&language=\(lang)&page=\(page)")!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(TMDBPage<TMDBMovie>.self, from: data).results
    }

    func trending(page: Int = 1, lang: String = "en-US") async throws -> [TMDBMovie] {
        let url = URL(string: "\(base)/trending/movie/week?api_key=\(apiKey)&language=\(lang)&page=\(page)")!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(TMDBPage<TMDBMovie>.self, from: data).results
    }

    func search(query: String, lang: String = "en-US") async throws -> [TMDBMovie] {
        let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "\(base)/search/movie?api_key=\(apiKey)&query=\(q)&language=\(lang)")!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(TMDBPage<TMDBMovie>.self, from: data).results
    }

    func videos(movieID: Int, lang: String = "en-US") async throws -> [TMDBVideo] {
        let url = URL(string: "\(base)/movie/\(movieID)/videos?api_key=\(apiKey)&language=\(lang)")!
        let (data, _) = try await session.data(from: url)
        let r = try JSONDecoder().decode(TMDBVideosResult.self, from: data)
        if r.results.isEmpty {
            let url2 = URL(string: "\(base)/movie/\(movieID)/videos?api_key=\(apiKey)&language=en")!
            let (d2, _) = try await session.data(from: url2)
            return try JSONDecoder().decode(TMDBVideosResult.self, from: d2).results
        }
        return r.results
    }

    func poster(_ path: String?, size: Int = 342) -> String? {
        guard let p = path else { return nil }
        return "\(imageBase)/w\(size)\(p)"
    }

    func backdrop(_ path: String?, size: Int = 780) -> String? {
        guard let p = path else { return nil }
        return "\(imageBase)/w\(size)\(p)"
    }

    func genreName(id: Int) -> String? {
        return Self.genres[id]
    }

    static let genres: [Int: String] = [
        28: "Action", 12: "Adventure", 16: "Animation", 35: "Comedy",
        80: "Crime", 99: "Documentary", 18: "Drama", 10751: "Family",
        14: "Fantasy", 36: "History", 27: "Horror", 10402: "Music",
        9648: "Mystery", 10749: "Romance", 878: "Sci-Fi", 10770: "TV Movie",
        53: "Thriller", 10752: "War", 37: "Western"
    ]
}

// MARK: - Models

struct TMDBPage<T: Codable>: Codable {
    let page: Int
    let results: [T]
    let total_pages: Int
    let total_results: Int
}

struct TMDBMovie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let release_date: String?
    let vote_average: Double?
    let genre_ids: [Int]?
    let popularity: Double?
    let original_language: String?
    let adult: Bool?
}

struct TMDBVideosResult: Codable {
    let results: [TMDBVideo]
}

struct TMDBVideo: Codable {
    let key: String
    let site: String?
    let type: String?
    let name: String?
}
