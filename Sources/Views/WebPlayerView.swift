import SwiftUI
import WebKit

struct WebPlayerView: View {
    let item: PlayableItem
    let onClose: () -> Void

    enum LoadState { case checking, trailer(URL), browser, error(String) }

    @State private var loadState = LoadState.checking
    @State private var webView: WKWebView? = nil
    @State private var isLoading = true
    @State private var showHint = true
    @State private var monitor: Any? = nil

    private var searchURL: URL {
        let q = item.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? item.title
        return URL(string: "https://www.tokyvideo.com/br/search?q=\(q)")!
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            switch loadState {
            case .checking:
                VStack(spacing: 16) {
                    Spacer()
                    ProgressView().progressViewStyle(.circular).scaleEffect(1.5)
                    Text("Looking for trailer...").font(.system(size: 14)).foregroundColor(Color(white: 0.5))
                    Spacer()
                }
            case .trailer(let url):
                WebViewWrapper(url: url, didStart: { isLoading = true }, didFinish: { self.didFinish() }, webView: $webView)
                    .ignoresSafeArea()
                if showHint {
                    VStack {
                        HStack {
                            Text("Press ESC to exit")
                                .font(.system(size: 12)).foregroundColor(Color(white: 0.6))
                                .padding(.horizontal, 14).padding(.vertical, 8)
                                .background(Color.black.opacity(0.7)).cornerRadius(6)
                            Spacer()
                        }.padding(16)
                        Spacer()
                    }.onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation(.easeOut(duration: 0.5)) { showHint = false }
                        }
                        enterFullscreen()
                    }
                }
            case .browser:
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Button { onClose() } label: {
                            Image(systemName: "xmark").font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white).padding(8)
                                .background(Color(white: 0.2)).clipShape(Circle())
                        }.buttonStyle(.plain)
                        Button { webView?.goBack() } label: {
                            Image(systemName: "chevron.left").font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white).padding(8)
                        }.buttonStyle(.plain)
                        Button { webView?.goForward() } label: {
                            Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white).padding(8)
                        }.buttonStyle(.plain)
                        Text(item.title).font(.system(size: 13, weight: .semibold)).foregroundColor(.white).lineLimit(1)
                        Spacer()
                    }.padding(.horizontal, 16).padding(.vertical, 10).background(Color(white: 0.1))
                    WebViewWrapper(url: searchURL, didStart: { isLoading = true }, didFinish: {}, webView: $webView)
                }
            case .error(let msg):
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "exclamationmark.triangle").font(.system(size: 40)).foregroundColor(Color(white: 0.3))
                    Text(msg).foregroundColor(Color(white: 0.5))
                    Button("Search on TokyoVideo") { loadState = .browser }
                        .buttonStyle(.plain).foregroundColor(.white)
                        .padding(.horizontal, 20).padding(.vertical, 8)
                        .background(Color(red: 0.898, green: 0.036, blue: 0.078)).cornerRadius(6)
                    Button("Close") { onClose() }.buttonStyle(.plain).foregroundColor(Color(white: 0.5)).padding(.top, 8)
                    Spacer()
                }
            }
        }
        .background(Color.black)
        .task { await loadTrailer() }
        .onDisappear { cleanupMonitor() }
    }

    private func didFinish() {
        isLoading = false
        injectFullscreenJS()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.injectFullscreenJS() }
    }

    private func enterFullscreen() { NSApp.windows.first?.toggleFullScreen(nil); setupEscapeMonitor() }

    private func setupEscapeMonitor() {
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 53 {
                NSApp.windows.first?.toggleFullScreen(nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { onClose() }
                return nil
            }
            return event
        }
    }

    private func cleanupMonitor() { if let m = monitor { NSEvent.removeMonitor(m); monitor = nil } }

    private func injectFullscreenJS() {
        let js = """
        (function() {
            var hide = [
                '#masthead-container', '#guide', '#related', '#comments',
                '#footer', '#chat-container', '#top-row', '#bottom-row',
                '#meta-contents', '#info-contents', '#info-bar',
                'ytd-video-primary-info-renderer', 'ytd-searchbox',
                'ytd-logo', 'ytd-masthead', '#movie_player > .ytp-chrome-top',
                'ytd-page-manager > ytd-watch-flexy > #columns > #secondary'
            ].join(', ');
            var s = document.createElement('style');
            s.textContent = hide + ' { display: none !important; }';
            document.documentElement.appendChild(s);
            document.documentElement.style.overflow = 'hidden';
            document.body.style.overflow = 'hidden';
            document.body.style.margin = '0';
            document.body.style.padding = '0';
            var p = document.getElementById('movie_player') || document.querySelector('.html5-video-player');
            if (p) {
                p.style.position = 'fixed';
                p.style.top = '0';
                p.style.left = '0';
                p.style.width = '100vw';
                p.style.height = '100vh';
                p.style.zIndex = '999999';
            }
            var v = document.querySelector('video');
            if (v) {
                v.style.width = '100%';
                v.style.height = '100%';
                v.style.objectFit = 'contain';
                v.muted = false;
                v.play();
            }
            var t;
            document.addEventListener('mousemove', function() {
                document.body.style.cursor = '';
                clearTimeout(t);
                t = setTimeout(function() { document.body.style.cursor = 'none'; }, 3000);
            });
        })();
        """
        webView?.evaluateJavaScript(js, completionHandler: nil)
    }

    private func loadTrailer() async {
        guard let id = item.tmdbID else {
            await MainActor.run { loadState = .browser }
            return
        }
        do {
            let videos = try await TMDBAPI.shared.videos(movieID: id)
            let trailer = videos.first(where: { $0.site == "YouTube" && $0.type == "Trailer" })
                ?? videos.first(where: { $0.site == "YouTube" })
            if let t = trailer {
                let url = URL(string: "https://www.youtube.com/watch?v=\(t.key)")!
                await MainActor.run { loadState = .trailer(url) }
                return
            }
        } catch {
            Log.debug("TMDB videos error: \(error.localizedDescription)")
        }
        await MainActor.run { loadState = .browser }
    }
}

struct WebViewWrapper: NSViewRepresentable {
    let url: URL
    let didStart: () -> Void
    let didFinish: () -> Void
    @Binding var webView: WKWebView?

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.mediaTypesRequiringUserActionForPlayback = []
        config.allowsAirPlayForMediaPlayback = true
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.navigationDelegate = context.coordinator
        wv.load(URLRequest(url: url))
        wv.allowsBackForwardNavigationGestures = true
        wv.setValue(false, forKey: "drawsBackground")
        DispatchQueue.main.async { webView = wv }
        return wv
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(didStart: didStart, didFinish: didFinish)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let didStart: () -> Void
        let didFinish: () -> Void
        init(didStart: @escaping () -> Void, didFinish: @escaping () -> Void) {
            self.didStart = didStart; self.didFinish = didFinish
        }
        func webView(_ wv: WKWebView, didStartProvisionalNavigation n: WKNavigation!) { didStart() }
        func webView(_ wv: WKWebView, didFinish n: WKNavigation!) { didFinish() }
        func webView(_ wv: WKWebView, didFail n: WKNavigation!, withError e: Error) { didFinish() }
    }
}
