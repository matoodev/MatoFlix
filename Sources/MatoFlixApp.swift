// Copyright (c) 2024-2026 MatoFlix, Inc. All rights reserved.

import SwiftUI

struct Log {
    static func debug(_ msg: String) {
        let date = ISO8601DateFormatter().string(from: Date()).suffix(15)
        fputs("[MatoFlix \(date)] \(msg)\n", stderr)
    }
}

@main
struct MatoFlixApp: App {
    init() {
        Log.debug("App launching...")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.black)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}
