import SwiftUI

struct TopNavBar: View {
    @Binding var selectedSection: String
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var searchResults: [TMDBMovie] = []
    @State private var searchTask: Task<Void, Never>? = nil
    @State private var isLoading = false
    @FocusState private var searchFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("MATOFLIX")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.898, green: 0.036, blue: 0.078))
                    .tracking(3.5)
                    .padding(.trailing, 28)
                    .onTapGesture { selectedSection = "Home" }

                HStack(spacing: 22) {
                    ForEach(["Home", "TV Shows", "Movies", "New & Popular", "My List"], id: \.self) { item in
                        VStack(spacing: 3) {
                            Text(item)
                                .font(.system(size: 13.5))
                                .fontWeight(item == selectedSection ? .semibold : .regular)
                                .foregroundColor(item == selectedSection ? .white : Color(white: 0.7))
                                .onTapGesture { selectedSection = item }

                            if item == selectedSection {
                                Rectangle()
                                    .fill(Color(red: 0.898, green: 0.036, blue: 0.078))
                                    .frame(width: 18, height: 2)
                                    .cornerRadius(1)
                            }
                        }
                    }
                }

                Spacer()

                HStack(spacing: 22) {
                    if isSearching {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(white: 0.5))
                                .font(.system(size: 14))
                            TextField("", text: $searchText, prompt: Text("Titles, people, genres").foregroundColor(Color(white: 0.5)))
                                .textFieldStyle(.plain)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .frame(width: 200)
                                .focused($searchFieldFocused)
                                .onChange(of: searchText) { newValue in
                                    searchTask?.cancel()
                                    if newValue.isEmpty { searchResults = []; return }
                                    searchTask = Task {
                                        try? await Task.sleep(nanoseconds: 300_000_000)
                                        if !Task.isCancelled { await performSearch(query: newValue) }
                                    }
                                }

                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .scaleEffect(0.6)
                                    .frame(width: 12, height: 12)
                            }

                            Button {
                                isSearching = false
                                searchText = ""
                                searchResults = []
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(white: 0.7))
                                    .font(.system(size: 13))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(white: 0.15))
                        .cornerRadius(4)
                    } else {
                        Button {
                            isSearching = true
                            searchFieldFocused = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                    }

                    Image(systemName: "bell")
                        .font(.system(size: 18))
                        .foregroundColor(.white)

                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.898, green: 0.036, blue: 0.078))
                                .frame(width: 32, height: 32)
                            Text("M")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 52)
            .padding(.vertical, 14)

            if isSearching && !searchResults.isEmpty {
                SearchResultsView(
                    movies: searchResults,
                    onSelect: { movie in
                        selectedSection = movie.title
                        searchText = ""
                        searchResults = []
                        isSearching = false
                        searchFieldFocused = false
                    },
                    onClose: { searchResults = [] }
                )
                .padding(.horizontal, 52)
                .padding(.top, 4)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    .black.opacity(0.98), .black.opacity(0.85), .black.opacity(0.4), .clear
                ]),
                startPoint: .top, endPoint: .bottom
            )
        )
    }

    private func performSearch(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        await MainActor.run { isLoading = true }
        do {
            let results = try await TMDBAPI.shared.search(query: query)
            if !Task.isCancelled {
                await MainActor.run {
                    searchResults = Array(results.prefix(15))
                    isLoading = false
                }
            }
        } catch {
            if !Task.isCancelled {
                await MainActor.run { isLoading = false }
            }
        }
    }
}
