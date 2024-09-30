import Foundation

struct Developers: Codable {
    let count: Int
    let next: String
    let prev: String?
    let results: [Developer]
}

struct Developer: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let slug: String
    let gameCount: Int
    let gamePhoto: String
    let description: String?
    let games: [GameSummary]?
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case gameCount = "games_count"
        case gamePhoto = "image_background"
        case description
        case games
    }
}
