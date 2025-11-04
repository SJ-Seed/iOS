//
//  PlantModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/25/25.
//

import Foundation
import SwiftUI

protocol PlantDisplayable {
    var plantProfile: PlantProfile { get }
    var dateText: String { get }
    var diagnosis: DiagnosisType { get }
}

extension MedicalRecord: PlantDisplayable {}
extension PlantInfo: PlantDisplayable {}

// MARK: - 홈 정보
struct PlantHomeInfo: Equatable, Codable {
    var plantProfile: PlantProfile
    var vitals: PlantVitals
}

struct PlantProfile: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var iconName: String
    var icon: Image { Image(iconName) }
}

enum SoilMoistureLevel: String, Equatable, Codable {
    case dry = "건조", normal = "적정", wet = "과습"
}

struct PlantVitals: Equatable, Codable {
    var temperature: Double
    var humidity: Double
    var soil: SoilMoistureLevel
}

// MARK: - 식물 정보
struct PlantInfo: Identifiable {
    let id = UUID()
    let plantProfile: PlantProfile
    let dateText: String
    let diagnosis: DiagnosisType
}

struct PlantAsset {
    let name: String       // 한글 이름
    let iconName: String   // 이미지 에셋 이름
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
