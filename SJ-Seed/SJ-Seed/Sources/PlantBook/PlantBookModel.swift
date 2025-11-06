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
        PlantAsset(name: "상추", iconName: "lettuce"),
        PlantAsset(name: "바질", iconName: "basil"),
        PlantAsset(name: "감자", iconName: "potato"),
        PlantAsset(name: "강낭콩", iconName: "bean"),
        PlantAsset(name: "토마토", iconName: "tomato"),
        PlantAsset(name: "딸기", iconName: "strawberry"),
        PlantAsset(name: "고추", iconName: "pepper"),
        PlantAsset(name: "블루베리", iconName: "blueberry"),
        PlantAsset(name: "체리", iconName: "cherry"),
        PlantAsset(name: "라즈베리", iconName: "raspberry"),
        PlantAsset(name: "포도", iconName: "grape"),
        PlantAsset(name: "복숭아", iconName: "peach")
    ]
}
