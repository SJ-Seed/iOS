//
//  PlantViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/25/25.
//

import Foundation
import SwiftUI

final class PlantStateViewModel: ObservableObject {
    @Published var plant: PlantHomeInfo
    @Published var statusMessage: String          // ← 서버/로직에서 그대로 주는 문자열
    @Published var shouldWater: Bool              // ← 물주기 필요 여부

    init(
        plant: PlantHomeInfo? = nil,
        statusMessage: String = "상태가 좋아요 🙂",
        shouldWater: Bool? = nil
    ) {
        // 기본값 설정 (초기 화면용 등)
        let defaultPlant = PlantHomeInfo(
            plantProfile: PlantProfile(
                id: UUID(),
                name: "토마토",
                iconName: "sprout"
            ),
            vitals: PlantVitals(
                temperature: 33,
                humidity: 65,
                soil: .dry
            )
        )

        // 주입된 plant가 있으면 그것을 사용
        self.plant = plant ?? defaultPlant
        self.statusMessage = statusMessage
        if let shouldWater {                      // 주입 우선
            self.shouldWater = shouldWater
        } else {
            self.shouldWater = (plant?.vitals.soil == .dry)   // 기본 휴리스틱
        }
    }
}
