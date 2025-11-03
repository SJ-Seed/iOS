//
//  CollectionResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation

struct IfNotLoseResult: Codable {
    let ifNotLose: Bool
    let name: String
}

struct ItemResult: Codable {
    let name: String
    let rarity: Int
}
