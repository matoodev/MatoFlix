import SwiftUI

struct SearchResultsView: View {
    let movies: [TMDBMovie]
    let onSelect: (TMDBMovie) -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Results")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(white: 0.5))
                Spacer()
                Text("\(movies.count) found")
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider()
                .background(Color(white: 0.2))

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(movies, id: \.id) { movie in
                        SearchResultRow(movie: movie)
                            .onTapGesture { onSelect(movie) }
                        Divider()
                            .background(Color(white: 0.1))
                            .padding(.leading, 100)
                    }
                }
            }
        }
        .frame(width: 480, height: 420)
        .background(Color(white: 0.08))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(white: 0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.6), radius: 30, x: 0, y: 10)
    }
}

struct SearchResultRow: View {
    let movie: TMDBMovie

    var body: some View {
        HStack(spacing: 14) {
            CardImageView(
                url: TMDBAPI.shared.poster(movie.poster_path),
                fallback: (0.15, 0.15, 0.15),
                text: movie.title
            )
            .frame(width: 56, height: 80)
            .cornerRadius(4)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    if let rating = movie.vote_average {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 9))
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", rating))
                                .font(.system(size: 11))
                                .foregroundColor(Color(white: 0.6))
                        }
                    }
                    if let year = movie.release_date {
                        Text(String(year.prefix(4)))
                            .font(.system(size: 11))
                            .foregroundColor(Color(white: 0.5))
                    }
                }

                if let overview = movie.overview {
                    Text(overview)
                        .font(.system(size: 10))
                        .foregroundColor(Color(white: 0.4))
                        .lineLimit(1)
                }
            }

            Spacer()

            Image(systemName: "play.circle")
                .font(.system(size: 20))
                .foregroundColor(Color(white: 0.4))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(white: 0.08))
        .contentShape(Rectangle())
    }
}
