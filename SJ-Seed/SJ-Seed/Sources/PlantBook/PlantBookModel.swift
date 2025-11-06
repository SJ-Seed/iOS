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
    var pieceId: Int?
    var speciesId: Int
}

struct PlantDetailModel {
    let description: String
    let growthProcess: String
    let goodEnvironment: String
    let watering: String
}

struct PlantAssets {
    static let all: [PlantAsset] = [
        PlantAsset(name: "상추", iconName: "lettuce", rarity: 1),     // speciesId: 1
        PlantAsset(name: "바질", iconName: "basil", rarity: 1),       // speciesId: 2
        PlantAsset(name: "감자", iconName: "potato", rarity: 1),      // speciesId: 3
        PlantAsset(name: "강낭콩", iconName: "bean", rarity: 2),      // speciesId: 4
        PlantAsset(name: "토마토", iconName: "tomato", rarity: 2),     // speciesId: 5
        PlantAsset(name: "딸기", iconName: "strawberry", rarity: 2),  // speciesId: 6
        PlantAsset(name: "고추", iconName: "pepper", rarity: 3),       // speciesId: 7
        PlantAsset(name: "블루베리", iconName: "blueberry", rarity: 3), // speciesId: 7
        PlantAsset(name: "체리", iconName: "cherry", rarity: 4),      // speciesId: 8
        PlantAsset(name: "라즈베리", iconName: "raspberry", rarity: 4),  // speciesId: 10
        PlantAsset(name: "포도", iconName: "grape", rarity: 5),       // speciesId: 11
        PlantAsset(name: "복숭아", iconName: "peach", rarity: 5)       // speciesId: 12
    ]
    
    // 이름으로 PlantAsset 객체 찾기
    static func find(by name: String) -> PlantAsset? {
        return all.first { $0.name == name }
    }
    
    // 이름으로 1-based "speciesId" 찾기 (LotteryView에서 사용)
    static func findSpeciesId(by name: String) -> Int? {
        guard let index = all.firstIndex(where: { $0.name == name }) else {
            return nil
        }
        return index + 1 // 0-based index를 1-based ID로 변환
    }
    
    // 1-based "speciesId"로 PlantAsset 객체 찾기 (DetailView에서 사용)
    static func find(bySpeciesId speciesId: Int) -> PlantAsset? {
        let index = speciesId - 1 // 1-based ID를 0-based index로 변환
        guard index >= 0 && index < all.count else {
            return nil
        }
        return all[index]
    }
}
