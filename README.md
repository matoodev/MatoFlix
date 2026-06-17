# matoflix

yo, welcome to matoflix — a netflix clone for macos built with swiftui.

got a sick hero section, horizontal movie rows, search with tmdb, trailer player, and a web player for when trailers ain't enough. all in a dark, sleek ui that looks like the real deal.

## features

- **hero section** — big featured movie with play button and details
- **movie rows** — trending, popular, new releases, categorized
- **search** — real-time search with tmdb, debounced 300ms
- **trailer player** — fetches youtube trailers from tmdb, fullscreen with esc to exit
- **web player** — falls back to tokyovideo search if no trailer found
- **account screen** — sign up / sign in flow (cosmetic)
- **responsive layout** — adapts to window size like a champ

## before you run

drop your own tmdb api key in `TMDBAPI.swift`:

```swift
private let apiKey = "your-tmdb-api-key-here"
```

get one free at https://www.themoviedb.org/settings/api

## build

```bash
./build.sh
./run.sh
```

## stack

swiftui + appkit + webkit. all compiled with swiftc, no xcode needed.

copyright (c) 2024-2026 matoflix, inc. all rights reserved.
