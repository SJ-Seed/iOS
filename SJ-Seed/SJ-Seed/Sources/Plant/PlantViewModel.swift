//
//  PlantViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/25/25.
//

import Foundation
import SwiftUI

final class PlantStateViewModel: ObservableObject {
    @Published var plant: PlantInfo
    @Published var statusMessage: String          // ← 서버/로직에서 그대로 주는 문자열
    @Published var shouldWater: Bool              // ← 물주기 필요 여부

    init(
        plant: PlantInfo = PlantInfo(
            name: "토마토",
            iconName: "sprout",
            vitals: .init(temperature: 33, humidity: 65, soil: .dry)
        ),
        statusMessage: String = "상태가 좋아요 🙂",
        shouldWater: Bool? = nil                  // 주입 없으면 간단한 휴리스틱으로 판단
    ) {
        self.plant = plant
        self.statusMessage = statusMessage
        if let shouldWater {                      // 주입 우선
            self.shouldWater = shouldWater
        } else {
            self.shouldWater = (plant.vitals.soil == .dry)   // 기본 휴리스틱
        }
    }
}
