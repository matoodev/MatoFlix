import SwiftUI

struct HeroView: View {
    let movie: Movie
    let height: CGFloat
    let titleSize: CGFloat
    let horizontalPad: CGFloat
    let isResponsive: Bool
    var onPlay: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ZStack {
                Color(
                    red: movie.bgColor.0,
                    green: movie.bgColor.1,
                    blue: movie.bgColor.2
                )

                Image(systemName: "play.square.fill")
                    .font(.system(size: isResponsive ? 80 : 160))
                    .foregroundColor(.white.opacity(0.06))

                LinearGradient(
                    gradient: Gradient(colors: [
                        .black.opacity(0.15),
                        .black.opacity(0.35),
                        .black.opacity(0.7),
                        .black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(height: height)

            VStack(alignment: .leading, spacing: 0) {
                Text(movie.title.uppercased())
                    .font(.system(size: titleSize, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 8)
                    .padding(.bottom, isResponsive ? 8 : 12)

                if !isResponsive {
                    HStack(spacing: 10) {
                        Text(movie.year)
                            .font(.system(size: 15))
                            .foregroundColor(Color(white: 0.7))

                        Text("•").foregroundColor(Color(white: 0.5)).font(.system(size: 10))

                        ZStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color(white: 0.2))
                                .frame(width: 30, height: 18)
                            Text(movie.rating)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(white: 0.7))
                        }

                        Text("•").foregroundColor(Color(white: 0.5)).font(.system(size: 10))

                        Text(movie.duration)
                            .font(.system(size: 15))
                            .foregroundColor(Color(white: 0.7))
                    }
                    .padding(.bottom, 14)

                    HStack(spacing: 6) {
                        ForEach(Array(movie.genres.enumerated()), id: \.offset) { i, genre in
                            Text(genre)
                                .font(.system(size: 14))
                                .foregroundColor(Color(white: 0.7))
                            if i < movie.genres.count - 1 {
                                Circle()
                                    .fill(Color(white: 0.4))
                                    .frame(width: 3, height: 3)
                            }
                        }
                    }
                    .padding(.bottom, 18)
                }

                if !isResponsive {
                    Text(movie.description)
                        .font(.system(size: 15))
                        .foregroundColor(Color(white: 0.75))
                        .lineLimit(height < 600 ? 2 : 3)
                        .lineSpacing(3)
                        .frame(maxWidth: 540, alignment: .leading)
                        .padding(.bottom, 22)

                    HStack(spacing: 14) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 16, weight: .bold))
                            Text("Play")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(6)
                        .onTapGesture { onPlay?() }
                        .contentShape(Rectangle())

                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 16))
                            Text("More Info")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 10)
                        .background(Color(white: 0.25).opacity(0.7))
                        .cornerRadius(6)
                    }
                }
            }
            .padding(.horizontal, horizontalPad)
            .padding(.bottom, isResponsive ? 60 : 100)
        }
    }
}
