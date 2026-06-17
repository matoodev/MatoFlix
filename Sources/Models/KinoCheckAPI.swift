import Foundation

struct KinoCheckAPI {
    static let shared = KinoCheckAPI()
    private let base = "https://api.kinocheck.com"
    private let session: URLSession = {
        let c = URLSessionConfiguration.default
        c.timeoutIntervalForRequest = 10
        return URLSession(configuration: c)
    }()

    func trailer(for imdbID: String) async -> String? {
        let url = URL(string: "\(base)/movies?imdb_id=\(imdbID)&language=en")!
        do {
            let (data, _) = try await session.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            if let trailer = json?["trailer"] as? [String: Any],
               let videoID = trailer["youtube_video_id"] as? String {
                return videoID
            }
        } catch {}
        return nil
    }
}
