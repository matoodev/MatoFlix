#!/bin/bash
cd "$(dirname "$0")"
swiftc -o MatoFlix.app/Contents/MacOS/MatoFlix \
    Sources/MatoFlixApp.swift \
    Sources/Views/ContentView.swift \
    Sources/Views/HomeView.swift \
    Sources/Views/HeroView.swift \
    Sources/Views/MovieCardView.swift \
    Sources/Views/MovieRowView.swift \
    Sources/Views/TopNavBar.swift \
    Sources/Views/SearchResultsView.swift \
    Sources/Views/PlayerView.swift \
    Sources/Views/WebPlayerView.swift \
    Sources/Views/AccountView.swift \
    Sources/Models/Movie.swift \
    Sources/Models/MovieData.swift \
    Sources/Models/TVModels.swift \
    Sources/Models/MovieAPI.swift \
    Sources/Models/TMDBAPI.swift \
    -framework SwiftUI \
    -framework AppKit \
    -framework WebKit
echo "Build complete."
