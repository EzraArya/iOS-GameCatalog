//
//  Screenshot.swift
//  GameCatalog
//
//  Created by Ezra Arya Wijaya on 30/08/24.
//

import Foundation

struct Screenshots: Codable {
    let count: Int
    let next: String?
    let prev: String?
    let results: [Screenshot]
}

struct Screenshot: Codable {
    let id: Int
    let image: String
    let hidden: Bool?
    let width: Int
    let height: Int
    let isDeleted: Bool
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case hidden
        case width
        case height
        case isDeleted = "is_deleted"
    }
}
