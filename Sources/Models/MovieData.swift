import Foundation

struct MovieData {
    static let movies: [Movie] = [
        Movie(title: "Tung Tung Tung Sahur & The Brainrots", description: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.", year: "2024", rating: "16", duration: "4 Seasons", genres: ["Sci-Fi", "Horror", "Drama"], isFeatured: true, bgColor: (0.6, 0.1, 0.15)),
        Movie(title: "The Crown", description: "This fictional dramatisation of the reign of Queen Elizabeth II chronicles the personal and political events that shaped her life.", year: "2023", rating: "14", duration: "6 Seasons", genres: ["Drama", "History"], isFeatured: false, bgColor: (0.2, 0.2, 0.35)),
        Movie(title: "Wednesday", description: "Smart, sarcastic and a little dead inside, Wednesday Addams investigates a murder spree while making new friends at Nevermore Academy.", year: "2024", rating: "14", duration: "2 Seasons", genres: ["Comedy", "Fantasy", "Horror"], isFeatured: true, bgColor: (0.15, 0.15, 0.25)),
        Movie(title: "The Witcher", description: "Geralt of Rivia, a solitary monster hunter, struggles to find his place in a world where people often prove more wicked than beasts.", year: "2023", rating: "18", duration: "3 Seasons", genres: ["Fantasy", "Action", "Adventure"], isFeatured: false, bgColor: (0.3, 0.2, 0.15)),
        Movie(title: "Squid Game", description: "Hundreds of cash-strapped players accept a strange invitation to compete in children's games with a deadly high stakes prize.", year: "2024", rating: "18", duration: "1 Season", genres: ["Thriller", "Drama", "Horror"], isFeatured: true, bgColor: (0.5, 0.08, 0.2)),
        Movie(title: "Money Heist", description: "A criminal mastermind who goes by 'The Professor' has a plan to pull off the biggest heist in recorded history.", year: "2023", rating: "16", duration: "5 Parts", genres: ["Action", "Crime", "Thriller"], isFeatured: false, bgColor: (0.55, 0.15, 0.08)),
        Movie(title: "Bridgerton", description: "The eight close-knit siblings of the Bridgerton family look for love and happiness in London high society.", year: "2024", rating: "14", duration: "3 Seasons", genres: ["Romance", "Drama"], isFeatured: false, bgColor: (0.45, 0.3, 0.35)),
        Movie(title: "Dark", description: "A missing child sets four families on a frantic hunt for answers as they unearth a mind-bending mystery that spans three generations.", year: "2022", rating: "16", duration: "3 Seasons", genres: ["Sci-Fi", "Thriller", "Mystery"], isFeatured: false, bgColor: (0.05, 0.05, 0.12)),
        Movie(title: "Lupin", description: "Inspired by the adventures of Arsène Lupin, gentleman thief Assane Diop sets out to avenge his father for an injustice.", year: "2024", rating: "14", duration: "3 Parts", genres: ["Crime", "Drama", "Mystery"], isFeatured: false, bgColor: (0.2, 0.15, 0.3)),
        Movie(title: "Arcane", description: "Amid the stark discord of twin cities Piltover and Zaun, two sisters fight on rival sides of a war between magic and technology.", year: "2024", rating: "14", duration: "1 Season", genres: ["Animation", "Action", "Fantasy"], isFeatured: true, bgColor: (0.1, 0.25, 0.45)),
        Movie(title: "The Night Agent", description: "A low-level FBI agent becomes embroiled in a conspiracy involving a double agent and a spy who died in his arms.", year: "2024", rating: "16", duration: "2 Seasons", genres: ["Action", "Thriller", "Drama"], isFeatured: false, bgColor: (0.2, 0.2, 0.3)),
        Movie(title: "Queen Charlotte", description: "The story of Queen Charlotte and King George III's marriage and the love story that sparked a societal shift.", year: "2023", rating: "14", duration: "1 Season", genres: ["Romance", "Drama"], isFeatured: false, bgColor: (0.35, 0.2, 0.3)),
        Movie(title: "Black Mirror", description: "An anthology series exploring a twisted, high-tech multiverse where humanity's greatest innovations and darkest instincts collide.", year: "2023", rating: "16", duration: "6 Seasons", genres: ["Sci-Fi", "Thriller"], isFeatured: false, bgColor: (0.05, 0.05, 0.08)),
        Movie(title: "Sex Education", description: "A socially awkward teenage boy with a sex therapist mother teams up with a bad girl to set up an underground sex therapy clinic.", year: "2023", rating: "16", duration: "4 Seasons", genres: ["Comedy", "Drama", "Romance"], isFeatured: false, bgColor: (0.35, 0.25, 0.12)),
        Movie(title: "Narcos", description: "The true story of the rise and fall of the most notorious drug kingpins in the late 20th century.", year: "2022", rating: "18", duration: "3 Seasons", genres: ["Crime", "Drama", "Thriller"], isFeatured: false, bgColor: (0.3, 0.2, 0.08)),
        Movie(title: "Umbrella Academy", description: "A disbanded group of superheroes reunite after their adoptive father's death to investigate his mysterious death.", year: "2024", rating: "14", duration: "4 Seasons", genres: ["Action", "Comedy", "Sci-Fi"], isFeatured: false, bgColor: (0.2, 0.15, 0.35)),
    ]

    static let categories: [Category] = [
        Category(name: "Trending Now"),
        Category(name: "Continue Watching"),
        Category(name: "Popular on MatoFlix"),
        Category(name: "New Releases"),
        Category(name: "TV Shows"),
        Category(name: "Movies"),
        Category(name: "Horror & Thriller"),
        Category(name: "Sci-Fi & Fantasy"),
    ]

    static let navItems = ["Home", "TV Shows", "Movies", "New & Popular", "My List"]
}
