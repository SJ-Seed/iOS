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

struct PlantDetailModel {
    let description: String
    let growthProcess: String
    let goodEnvironment: String
    let watering: String
}

struct PlantAssets {
    static let all: [PlantAsset] = [
        PlantAsset(name: "상추", iconName: "lettuce", rarity: 1),     // pieceId: 0
        PlantAsset(name: "바질", iconName: "basil", rarity: 1),       // pieceId: 1
        PlantAsset(name: "감자", iconName: "potato", rarity: 1),      // pieceId: 2
        PlantAsset(name: "강낭콩", iconName: "bean", rarity: 2),      // pieceId: 3
        PlantAsset(name: "토마토", iconName: "tomato", rarity: 2),     // pieceId: 4
        PlantAsset(name: "딸기", iconName: "strawberry", rarity: 2),  // pieceId: 5
        PlantAsset(name: "고추", iconName: "pepper", rarity: 3),       // pieceId: 6
        PlantAsset(name: "블루베리", iconName: "blueberry", rarity: 3), // pieceId: 7
        PlantAsset(name: "체리", iconName: "cherry", rarity: 4),      // pieceId: 8
        PlantAsset(name: "라즈베리", iconName: "raspberry", rarity: 4),  // pieceId: 9
        PlantAsset(name: "포도", iconName: "grape", rarity: 5),       // pieceId: 10
        PlantAsset(name: "복숭아", iconName: "peach", rarity: 5)       // pieceId: 11
    ]
    
    // 1. ‼️ 이름으로 PlantAsset 객체를 찾는 함수 (추가)
    static func find(by name: String) -> PlantAsset? {
        return all.first { $0.name == name }
    }
    
    // 2. ‼️ 이름으로 pieceId(인덱스)를 찾는 함수 (추가)
//    static func findPieceId(by name: String) -> Int? {
//        return all.firstIndex { $0.name == name }
//    }

    // 3. 기존 pieceId(인덱스)로 찾는 함수 (유지)
//    static func find(by pieceId: Int) -> PlantAsset? {
//        guard pieceId >= 0 && pieceId < all.count else {
//            print("❌ PlantAssets.find: 잘못된 pieceId(\(pieceId))입니다.")
//            return nil
//        }
//        return all[pieceId]
//    }
}
