//
//  PlantBookModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/30/25.
//

import Foundation

struct PlantBookModel: Identifiable, Codable, Equatable {
    let id: UUID
    var plant: PlantProfile
    var rarity: Int
}
