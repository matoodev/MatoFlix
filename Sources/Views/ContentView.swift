import SwiftUI

struct ContentView: View {
    @State private var selectedSection = "Home"
    @State private var isLoggedIn = false
    @State private var playingItem: PlayableItem?

    var body: some View {
        ZStack {
            Group {
                if !isLoggedIn {
                    AccountView(isLoggedIn: $isLoggedIn)
                        .onAppear { Log.debug("View: AccountView") }
                } else {
                    MainView(
                        selectedSection: $selectedSection,
                        onPlayItem: { playingItem = $0 }
                    )
                }
            }
            .frame(minWidth: isLoggedIn ? 800 : 700, minHeight: 500)

            if let item = playingItem {
                WebPlayerView(item: item, onClose: { playingItem = nil; Log.debug("Player closed: \(item.title)") })
                    .zIndex(100)
            }
        }
    }
}

struct MainView: View {
    @Binding var selectedSection: String
    let onPlayItem: (PlayableItem) -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                HomeView(
                    selectedSection: $selectedSection,
                    windowWidth: max(geo.size.width, 800),
                    windowHeight: max(geo.size.height, 500),
                    onPlayItem: onPlayItem
                )
                TopNavBar(selectedSection: $selectedSection)
            }
            .background(Color.black)
            .preferredColorScheme(.dark)
        }
    }
}
