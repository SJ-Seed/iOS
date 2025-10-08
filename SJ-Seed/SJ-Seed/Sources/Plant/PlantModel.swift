//
//  PlantModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/25/25.
//

import Foundation
import SwiftUI

// MARK: - 식물 정보
struct PlantInfo: Equatable, Codable {
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
