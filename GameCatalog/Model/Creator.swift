import Foundation

struct Creators: Codable {
    let count: Int
    let next: String
    let prev: String?
    let results: [Creator]
}

struct Creator: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let slug: String
    let image: String?
    let backgroundImage: String?
    let gameCount: Int
    let description: String?
    let games: [GameSummary]?
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case image
        case backgroundImage = "image_background"
        case gameCount = "games_count"
        case description
        case games
    }
}
