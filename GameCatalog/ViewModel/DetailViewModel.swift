import Foundation

struct DetailContent {
    let name: String
    let imageURL: String
    let rating: Double?
    let releasedDate: String?
    let gamesCount: Int?
    let games: [GameSummary]?
    let description: String?
    let screenshot: [Screenshot]?
    let achievement: [Achievement]?
    let metacritic: Int?
    let game: Game?
    let developer: Developer?
    let creator: Creator?
}

@MainActor
class DetailViewModel: ObservableObject {
    @Published var content: DetailContent?
    let id: Int
    let filter: HomeViewModel.ButtonFilter
    init(id: Int, filter: HomeViewModel.ButtonFilter) {
        self.id = id
        self.filter = filter
    }
    var title: String {
        switch filter {
        case .games:
            return "Game Details"
        case .developers:
            return "Developer Details"
        case .creators:
            return "Creator Details"
        }
    }
    func fetchDetails() async {
        let urlString: String
        switch filter {
        case .games:
            urlString = "https://api.rawg.io/api/games/\(id)?key=\(APIKey)"
        case .developers:
            urlString = "https://api.rawg.io/api/developers/\(id)?key=\(APIKey)"
        case .creators:
            urlString = "https://api.rawg.io/api/creators/\(id)?key=\(APIKey)"
        }
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Server error")
                return
            }
            switch filter {
            case .games:
                let decodedResponse = try JSONDecoder().decode(Game.self, from: data)
                async let screenshot = fetchScreenshot(slug: decodedResponse.slug)
                async let achievement = fetchAchievement(slug: decodedResponse.slug)
                content = await DetailContent(name: decodedResponse.name,
                                        imageURL: decodedResponse.gamePhoto,
                                        rating: decodedResponse.ratingGame,
                                        releasedDate: decodedResponse.releasedDate,
                                        gamesCount: nil,
                                        games: nil,
                                        description: decodedResponse.description,
                                        screenshot: screenshot,
                                        achievement: achievement,
                                        metacritic: decodedResponse.metacritic,
                                        game: decodedResponse,
                                        developer: nil,
                                        creator: nil
                )
            case .developers:
                let decodedResponse = try JSONDecoder().decode(Developer.self, from: data)
                content = DetailContent(name: decodedResponse.name,
                                        imageURL: decodedResponse.gamePhoto,
                                        rating: nil,
                                        releasedDate: nil,
                                        gamesCount: decodedResponse.gameCount,
                                        games: decodedResponse.games,
                                        description: decodedResponse.description,
                                        screenshot: nil,
                                        achievement: nil,
                                        metacritic: nil,
                                        game: nil,
                                        developer: decodedResponse,
                                        creator: nil
                )
            case .creators:
                let decodedResponse = try JSONDecoder().decode(Creator.self, from: data)
                content = DetailContent(name: decodedResponse.name,
                                        imageURL: decodedResponse.image ?? "https://t3.ftcdn.net/jpg/01/65/63/94/360_F_165639425_kRh61s497pV7IOPAjwjme1btB8ICkV0L.jpg",
                                        rating: nil,
                                        releasedDate: nil,
                                        gamesCount: decodedResponse.gameCount,
                                        games: decodedResponse.games,
                                        description: decodedResponse.description,
                                        screenshot: nil,
                                        achievement: nil,
                                        metacritic: nil,
                                        game: nil,
                                        developer: nil,
                                        creator: decodedResponse
                )
            }
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }
    func fetchScreenshot(slug: String) async -> [Screenshot]? {
        let urlString = "https://api.rawg.io/api/games/\(slug)/screenshots?key=\(APIKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Server error")
                return nil
            }
            let decodedResponse = try JSONDecoder().decode(Screenshots.self, from: data)
            return decodedResponse.results
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return nil
        }
    }
    func fetchAchievement(slug: String) async -> [Achievement]? {
        let urlString = "https://api.rawg.io/api/games/\(slug)/achievements?key=\(APIKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Server error")
                return nil
            }
            let decodedResponse = try JSONDecoder().decode(Achievements.self, from: data)
            return decodedResponse.results
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return nil
        }
    }
}

extension String {
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options:
                    [
                        .documentType: NSAttributedString.DocumentType.html,
                            .characterEncoding: String.Encoding.utf8.rawValue
                    ],
                documentAttributes: nil
            )
        } catch {
            print("Error converting HTML to NSAttributedString: \(error)")
            return nil
        }
    }

    func htmlToString() -> String {
        return htmlToAttributedString()?.string ?? self
    }
}
