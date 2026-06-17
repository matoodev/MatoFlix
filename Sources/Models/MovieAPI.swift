import Foundation

struct MovieAPI {
    static let shared = MovieAPI()
    private let base = "https://api.tvmaze.com"
    private let session: URLSession = {
        let c = URLSessionConfiguration.default
        c.timeoutIntervalForRequest = 15
        c.timeoutIntervalForResource = 30
        return URLSession(configuration: c)
    }()

    func search(query: String) async throws -> [TVShow] {
        Log.debug("API search: \(query)")
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "\(base)/search/shows?q=\(encoded)") else { return [] }
        let (data, _) = try await session.data(from: url)
        let results = try JSONDecoder().decode([TVShowResponse].self, from: data)
        Log.debug("API search: \(results.count) results")
        return results.map(\.show)
    }

    func shows() async throws -> [TVShow] {
        Log.debug("API shows page 0...")
        guard let url = URL(string: "\(base)/shows?page=0") else { return [] }
        let (data, _) = try await session.data(from: url)
        let shows = try JSONDecoder().decode([TVShow].self, from: data)
        Log.debug("API shows: \(shows.count) loaded")
        return shows
    }
}
