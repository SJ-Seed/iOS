//
//  PlantStateViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/25/25.
//

import Foundation
import SwiftUI

final class PlantStateViewModel: ObservableObject {
    let plantId: Int
    @Published var plant: PlantHomeInfo
    @Published var statusMessage: String          // ← 서버/로직에서 그대로 주는 문자열
    @Published var shouldWater: Bool              // ← 물주기 필요 여부

    init(
        plantId: Int = 0,
        plant: PlantHomeInfo? = nil,
        statusMessage: String = "",
        shouldWater: Bool? = nil
    ) {
        // 기본값 설정 (초기 화면용 등)
        let defaultPlant = PlantHomeInfo(
            plantProfile: PlantProfile(
                id: UUID(),
                name: "",
                iconName: ""
            ),
            vitals: PlantVitals(
                temperature: 0,
                humidity: 0,
                soil: .normal
            )
        )

        // 주입된 plant가 있으면 그것을 사용
        self.plantId = plantId
        self.plant = plant ?? defaultPlant
        self.statusMessage = statusMessage
        if let shouldWater {                      // 주입 우선
            self.shouldWater = shouldWater
        } else {
            self.shouldWater = (plant?.vitals.soil == .dry)   // 기본 휴리스틱
        }
    }
}
