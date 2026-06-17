import Foundation

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let year: String
    let rating: String
    let duration: String
    let genres: [String]
    let isFeatured: Bool
    let bgColor: (Double, Double, Double)
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
}

struct PlayableItem {
    let title: String
    let genres: [String]
    let year: String
    let rating: String
    let imageUrl: String?
    let imdbID: String?
    let tmdbID: Int?
}

extension PlayableItem {
    init(movie: Movie) {
        title = movie.title
        genres = movie.genres
        year = movie.year
        rating = movie.rating
        imageUrl = nil
        imdbID = nil
        tmdbID = nil
    }

    init(tmdb: TMDBMovie) {
        title = tmdb.title
        genres = []
        year = tmdb.release_date.map { String($0.prefix(4)) } ?? "N/A"
        rating = tmdb.vote_average.map { String(format: "%.1f", $0) } ?? "NR"
        imageUrl = TMDBAPI.shared.poster(tmdb.poster_path)
        imdbID = nil
        tmdbID = tmdb.id
    }
}
