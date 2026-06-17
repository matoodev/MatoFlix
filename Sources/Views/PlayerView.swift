import SwiftUI

struct PlayerView: View {
    let item: PlayableItem
    let onClose: () -> Void

    @State private var isPlaying = false
    @State private var progress: Double = 0.27

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button { onClose() } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left").font(.system(size: 14, weight: .semibold))
                            Text("Back to Browse").font(.system(size: 14))
                        }
                        .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Image(systemName: "pip").font(.system(size: 16)).foregroundColor(.white).padding(.trailing, 16)
                    Image(systemName: "airplayaudio").font(.system(size: 16)).foregroundColor(.white).padding(.trailing, 16)
                    Image(systemName: "xmark").font(.system(size: 16)).foregroundColor(.white)
                        .onTapGesture { onClose() }
                }
                .padding(.horizontal, 24).padding(.top, 16)

                Spacer()

                VStack(spacing: 16) {
                    Color(white: 0.1).frame(width: 200, height: 280).cornerRadius(8)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "play.slash").foregroundColor(Color(white: 0.3))
                                Text(item.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(white: 0.5))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                            }
                        )

                    Text(item.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)

                    if !item.genres.isEmpty {
                        Text(item.genres.joined(separator: " • "))
                            .font(.system(size: 13))
                            .foregroundColor(Color(white: 0.5))
                    }

                    Text("Sample Player • Content not available for streaming")
                        .font(.system(size: 11))
                        .foregroundColor(Color(white: 0.3))
                        .padding(.top, 4)
                }

                Spacer()

                VStack(spacing: 8) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle().fill(Color(white: 0.2)).frame(height: 4)
                            Rectangle().fill(.white).frame(width: geo.size.width * progress, height: 4)
                        }.cornerRadius(2)
                    }.frame(height: 4).padding(.horizontal, 40)

                    HStack {
                        Text("11:32").font(.system(size: 11)).foregroundColor(Color(white: 0.4))
                        Spacer()
                        Text("-30:46").font(.system(size: 11)).foregroundColor(Color(white: 0.4))
                    }.padding(.horizontal, 40)

                    HStack(spacing: 30) {
                        Image(systemName: "backward.end.fill").font(.system(size: 16)).foregroundColor(.white)

                        Button { isPlaying.toggle() } label: {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 52)).foregroundColor(.white)
                        }.buttonStyle(.plain)

                        Image(systemName: "forward.end.fill").font(.system(size: 16)).foregroundColor(.white)
                    }.padding(.bottom, 8)

                    HStack(spacing: 24) {
                        Image(systemName: "subtitles").font(.system(size: 14)).foregroundColor(.white)
                        Image(systemName: "speaker.wave.3.fill").font(.system(size: 14)).foregroundColor(.white)
                        Image(systemName: "play.rectangle.fill").font(.system(size: 14)).foregroundColor(.white)
                        Spacer()
                        Image(systemName: "sparkles.tv").font(.system(size: 14)).foregroundColor(.white)
                    }.padding(.horizontal, 40)
                }.padding(.bottom, 40)
            }
        }
    }
}
