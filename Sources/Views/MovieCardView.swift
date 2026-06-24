import SwiftUI
import AppKit

// MARK: - Image Cache
private let imageCache = NSCache<NSString, NSImage>()

// MARK: - Card Image Loader
struct CardImageView: View {
    let url: String?
    let fallback: (Double, Double, Double)
    let text: String

    @State private var nsImage: NSImage? = nil
    @State private var loaded = false

    var body: some View {
        Group {
            if let img = nsImage {
                Image(nsImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack {
                    Color(red: fallback.0, green: fallback.1, blue: fallback.2)
                    Text(text.prefix(2).uppercased())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
        }
        .frame(width: 178, height: 100)
        .clipped()
        .task { await load() }
    }

    @MainActor
    private func load() async {
        guard let url, let imgUrl = URL(string: url) else {
            Log.debug("Image load skipped: nil url")
            return
        }
        let key = url as NSString
        if let cached = imageCache.object(forKey: key) {
            await MainActor.run { nsImage = cached }
            return
        }
        do {
            Log.debug("Loading image: \(url.suffix(30))")
            let (data, _) = try await URLSession.shared.data(from: imgUrl)
            if let img = NSImage(data: data) {
                imageCache.setObject(img, forKey: key)
                await MainActor.run { nsImage = img }
                Log.debug("Image loaded: \(url.suffix(30))")
            } else {
                Log.debug("Image decode failed: \(url.suffix(30))")
            }
        } catch {
            Log.debug("Image error: \(url.suffix(30)) - \(error.localizedDescription)")
        }
    }
}

// MARK: - Card Action Button
struct CardActionButton: View {
    let icon: String
    let size: CGFloat
    let action: (() -> Void)?

    var body: some View {
        Button { action?() } label: {
            Circle()
                .strokeBorder(Color(white: 0.7), lineWidth: 1.5)
                .frame(width: 26, height: 26)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: size, weight: .bold))
                        .foregroundColor(.white)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Card Info Panel
struct CardInfoPanel: View {
    let title: String
    let subtitle: String
    let year: String
    var onPlay: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                CardActionButton(icon: "play.fill", size: 11, action: onPlay)
                CardActionButton(icon: "plus", size: 12, action: nil)
                CardActionButton(icon: "hand.thumbsup.fill", size: 10, action: nil)
                Spacer()
                CardActionButton(icon: "chevron.down", size: 10, action: nil)
            }
            .padding(.horizontal, 10).padding(.top, 8)

            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.horizontal, 10).padding(.top, 8)

            HStack(spacing: 4) {
                Text(subtitle)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Color(red: 0.4, green: 0.75, blue: 0.4))
                Text("•").foregroundColor(Color(white: 0.4))
                Text(year).font(.system(size: 9)).foregroundColor(Color(white: 0.6))
            }
            .padding(.horizontal, 10).padding(.top, 3).padding(.bottom, 10)
        }
        .background(Color(white: 0.08).cornerRadius(8))
    }
}

// MARK: - Static Movie Card
struct MovieCardView: View {
    let movie: Movie
    @State private var hover = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: movie.bgColor.0, green: movie.bgColor.1, blue: movie.bgColor.2)

            if hover {
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                    startPoint: .center, endPoint: .bottom
                )
                VStack(spacing: 0) {
                    Spacer()
                    CardInfoPanel(title: movie.title, subtitle: "\(movie.rating)+", year: movie.year)
                }
            }

            if !hover {
                VStack {
                    Spacer()
                    Text(movie.title)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 4).padding(.bottom, 6)
                }
            }
        }
        .frame(width: 178, height: 100)
        .cornerRadius(4)
        .onHover { hover = $0 }
    }
}

// MARK: - TMDB Movie Card
struct TMDBMovieCardView: View {
    let movie: TMDBMovie
    let onPlay: (() -> Void)?
    @State private var hover = false

    private var bg: (Double, Double, Double) {
        let colors: [(Double, Double, Double)] = [
            (0.4, 0.15, 0.15), (0.15, 0.25, 0.4), (0.3, 0.2, 0.25),
            (0.2, 0.3, 0.2), (0.4, 0.3, 0.1), (0.1, 0.2, 0.35),
            (0.35, 0.15, 0.25), (0.2, 0.2, 0.2),
        ]
        return colors[abs(movie.id.hashValue) % colors.count]
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            CardImageView(url: TMDBAPI.shared.poster(movie.poster_path), fallback: bg, text: movie.title)

            if hover {
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                    startPoint: .center, endPoint: .bottom
                )
                VStack(spacing: 0) {
                    Spacer()
                    CardInfoPanel(
                        title: movie.title,
                        subtitle: movie.vote_average.map { String(format: "%.1f", $0) } ?? "NR",
                        year: movie.release_date.map { String($0.prefix(4)) } ?? "",
                        onPlay: onPlay
                    )
                }
            }

            if !hover {
                VStack {
                    Spacer()
                    Text(movie.title)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 4).padding(.bottom, 6)
                }
            }
        }
        .frame(width: 178, height: 100)
        .cornerRadius(4)
        .onHover { hover = $0 }
    }
}
