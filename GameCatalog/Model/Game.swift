import Foundation

struct Games: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [Game]
}

struct Game: Codable, Identifiable, Hashable {
    let id: Int
    let slug: String
    let name: String
    let description: String?
    let metacritic: Int?
    let gamePhoto: String
    let ratingGame: Double
    let releasedDate: String
    let ratingsGame: [Ratings]
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case description
        case metacritic
        case releasedDate = "released"
        case gamePhoto = "background_image"
        case ratingGame = "rating"
        case ratingsGame = "ratings"
    }
}

struct Ratings: Codable, Hashable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double
}

struct GameSummary: Codable, Identifiable, Hashable {
    let id: Int
    let slug: String
    let name: String
    let added: Int
}
