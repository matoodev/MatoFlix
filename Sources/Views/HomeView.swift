import SwiftUI

struct HomeView: View {
    @Binding var selectedSection: String
    let windowWidth: CGFloat
    let windowHeight: CGFloat
    let onPlayItem: (PlayableItem) -> Void

    @State private var popularMovies: [TMDBMovie] = []
    @State private var searchMovies: [TMDBMovie] = []
    @State private var isLoading = true

    private var isResponsive: Bool { windowWidth < 1100 }
    private var horizontalPad: CGFloat {
        if windowWidth < 800 { return 24 }
        if windowWidth < 1100 { return 36 }
        return 52
    }
    private var heroHeight: CGFloat {
        if windowHeight < 600 { return 340 }
        if windowHeight < 800 { return 440 }
        return 580
    }
    private var heroTitleSize: CGFloat {
        if windowWidth < 900 { return 32 }
        if windowWidth < 1200 { return 40 }
        return 52
    }

    private var featured: Movie? {
        guard !popularMovies.isEmpty else { return nil }
        guard let first = popularMovies.first else { return nil }
        return Movie(
            title: first.title,
            description: first.overview ?? "",
            year: first.release_date.map { String($0.prefix(4)) } ?? "N/A",
            rating: first.vote_average.map { String(format: "%.1f", $0) } ?? "NR",
            duration: "2h",
            genres: first.genre_ids?.compactMap { id in TMDBAPI.shared.genreName(id: id) } ?? [],
            isFeatured: true,
            bgColor: (0.2, 0.2, 0.3)
        )
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                if selectedSection == "Home" || selectedSection == "TV Shows" || selectedSection == "Movies" || selectedSection == "New & Popular" {
                    if let hero = featured {
                        responsiveHero(movie: hero, play: { onPlayItem(PlayableItem(movie: hero)) })
                    }
                }

                VStack(spacing: isResponsive ? 20 : 28) {
                    if isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(1.2)
                            Text("Loading movies...")
                                .font(.system(size: 14))
                                .foregroundColor(Color(white: 0.5))
                        }
                        .padding(.top, 40)
                    } else {
                        contentRows
                    }
                }
                .padding(.top, selectedSection == "Home" || selectedSection == "TV Shows" || selectedSection == "Movies" || selectedSection == "New & Popular" ? -50 : 20)

                footer
            }
            .padding(.bottom, windowHeight * 0.05)
        }
        .background(Color.black)
        .task { await loadData() }
    }

    @ViewBuilder
    private var contentRows: some View {
        let rows = filteredCategories

        if rows.isEmpty && selectedSection != "My List" {
            VStack(spacing: 20) {
                Image(systemName: "film")
                    .font(.system(size: 50))
                    .foregroundColor(Color(white: 0.3))
                Text("No results found")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(white: 0.5))
            }
            .padding(.top, 60)
        }

        if selectedSection == "My List" {
            TMDBMovieRowView(
                title: "My List",
                movies: Array(popularMovies.prefix(10)),
                horizontalPad: horizontalPad,
                isResponsive: isResponsive,
                onPlayItem: onPlayItem
            )
        }

        ForEach(rows) { category in
            if category.name == "Popular on MatoFlix" && !popularMovies.isEmpty {
                TMDBMovieRowView(
                    title: category.name,
                    movies: Array(popularMovies.prefix(isResponsive ? 15 : 20)),
                    horizontalPad: horizontalPad,
                    isResponsive: isResponsive,
                    onPlayItem: onPlayItem
                )
            } else if category.name == "Trending Now" {
                TMDBMovieRowView(
                    title: category.name,
                    movies: Array(popularMovies.shuffled().prefix(isResponsive ? 15 : 20)),
                    horizontalPad: horizontalPad,
                    isResponsive: isResponsive,
                    onPlayItem: onPlayItem
                )
            } else if category.name == "Top Picks for You" && !searchMovies.isEmpty {
                TMDBMovieRowView(
                    title: category.name,
                    movies: Array(searchMovies.shuffled().prefix(isResponsive ? 12 : 20)),
                    horizontalPad: horizontalPad,
                    isResponsive: isResponsive,
                    onPlayItem: onPlayItem
                )
            } else {
                TMDBMovieRowView(
                    title: category.name,
                    movies: Array(popularMovies.shuffled().prefix(isResponsive ? 12 : 15)),
                    horizontalPad: horizontalPad,
                    isResponsive: isResponsive,
                    onPlayItem: onPlayItem
                )
            }
        }
    }

    @State private var showAllMovies = false

    private var filteredCategories: [Category] {
        let allCategories = [
            Category(name: "Trending Now"),
            Category(name: "Popular on MatoFlix"),
            Category(name: "New Releases"),
            Category(name: "TV Shows"),
            Category(name: "Movies"),
            Category(name: "Horror & Thriller"),
            Category(name: "Sci-Fi & Fantasy"),
        ]
        switch selectedSection {
        case "TV Shows":
            return allCategories.filter {
                $0.name.contains("TV") || $0.name.contains("Sci-Fi") || $0.name.contains("Horror")
            }
        case "Movies":
            return allCategories.filter {
                $0.name.contains("Movies") || $0.name.contains("Action") || $0.name.contains("Drama")
            }
        case "New & Popular":
            return [Category(name: "Trending Now"), Category(name: "Popular on MatoFlix"), Category(name: "New Releases")]
        case "My List":
            return []
        default:
            return allCategories
        }
    }

    private func responsiveHero(movie: Movie, play: @escaping () -> Void) -> some View {
        HeroView(
            movie: movie,
            height: heroHeight,
            titleSize: heroTitleSize,
            horizontalPad: horizontalPad,
            isResponsive: isResponsive,
            onPlay: play
        )
    }

    @ViewBuilder
    private var footer: some View {
        VStack(spacing: 14) {
            if !isResponsive {
                HStack(spacing: 36) {
                    footerCol("Audio Description", "Help Center", "Gift Cards", "Media Center")
                    footerCol("Terms of Use", "Privacy", "Cookie Preferences", "Corporate Information")
                    footerCol("Contact Us", "Speed Test", "Legal Notices", "Only on MatoFlix")
                }
            } else {
                footerCol("Help Center", "Terms of Use", "Privacy", "Contact Us")
            }

            Button("Service Code") {}
                .font(.system(size: 13))
                .foregroundColor(Color(white: 0.5))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color(white: 0.3), lineWidth: 1))
                .buttonStyle(.plain)

            Text("© 2024-2026 MatoFlix, Inc.")
                .font(.system(size: 11))
                .foregroundColor(Color(white: 0.35))
        }
        .font(.system(size: 13))
        .foregroundColor(Color(white: 0.5))
        .padding(.top, 40)
    }

    private func footerCol(_ items: String...) -> some View {
        VStack(spacing: 10) {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
        }
    }

    private func loadData() async {
        Log.debug("Starting TMDB load...")
        do {
            async let popular = TMDBAPI.shared.popular()
            async let searched = TMDBAPI.shared.search(query: "movie")
            let (p, s) = try await (popular, searched)
            try Task.checkCancellation()
            let pFiltered = p.filter { $0.poster_path != nil }
            let sFiltered = s.filter { $0.poster_path != nil }
            let limitedP = pFiltered.count > 80 ? Array(pFiltered.prefix(80)) : pFiltered
            let limitedS = sFiltered.count > 30 ? Array(sFiltered.prefix(30)) : sFiltered
            Log.debug("TMDB loaded: \(limitedP.count) popular, \(limitedS.count) search")
            await MainActor.run {
                guard !Task.isCancelled else { return }
                popularMovies = limitedP
                searchMovies = limitedS
                isLoading = false
                Log.debug("UI updated with TMDB movies")
            }
        } catch {
            Log.debug("TMDB error: \(error.localizedDescription)")
            await MainActor.run {
                guard !Task.isCancelled else { return }
                isLoading = false
            }
        }
    }
}
