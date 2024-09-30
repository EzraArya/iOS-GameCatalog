//
//  Achievement.swift
//  GameCatalog
//
//  Created by Ezra Arya Wijaya on 30/08/24.
//

import Foundation

struct Achievements: Codable {
    let count: Int
    let next: String?
    let prev: String?
    let results: [Achievement]
}

struct Achievement: Codable {
    let id: Int
    let name: String
    let description: String
    let image: String
    let percent: String
}
