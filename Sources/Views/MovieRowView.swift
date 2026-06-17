import SwiftUI

struct MovieRowView: View {
    let title: String
    let movies: [Movie]
    let horizontalPad: CGFloat
    let isResponsive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: isResponsive ? 16 : 20, weight: .bold))
                    .foregroundColor(.white)

                Image(systemName: "chevron.right")
                    .font(.system(size: isResponsive ? 9 : 11, weight: .bold))
                    .foregroundColor(Color(white: 0.5))
            }
            .padding(.horizontal, horizontalPad)
            .padding(.bottom, isResponsive ? 8 : 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(movies) { movie in
                        MovieCardView(movie: movie)
                    }
                }
                .padding(.horizontal, horizontalPad)
                .padding(.vertical, 4)
            }
        }
        .padding(.bottom, isResponsive ? 4 : 6)
    }
}

struct TMDBMovieRowView: View {
    let title: String
    let movies: [TMDBMovie]
    let horizontalPad: CGFloat
    let isResponsive: Bool
    let onPlayItem: ((PlayableItem) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: isResponsive ? 16 : 20, weight: .bold))
                    .foregroundColor(.white)

                Image(systemName: "chevron.right")
                    .font(.system(size: isResponsive ? 9 : 11, weight: .bold))
                    .foregroundColor(Color(white: 0.5))
            }
            .padding(.horizontal, horizontalPad)
            .padding(.bottom, isResponsive ? 8 : 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(movies, id: \.id) { movie in
                        TMDBMovieCardView(movie: movie, onPlay: onPlayItem.map { cb in { cb(PlayableItem(tmdb: movie)) } })
                    }
                }
                .padding(.horizontal, horizontalPad)
                .padding(.vertical, 4)
            }
        }
        .padding(.bottom, isResponsive ? 4 : 6)
    }
}
