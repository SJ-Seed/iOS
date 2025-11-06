//
//  CollectionResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation

struct RandomResult: Codable {
    let ifNotLose: Bool
    let name: String?
    let pieceId: Int?
}

struct PieceListItem: Codable {
    let name: String
    let rarity: Int
}

struct PieceDetail: Codable {
    let name: String
    let properTemp: String
    let properHum: String
    let process: String
    let water: String
    let description: String
    let rarity: Int // 임시
}
