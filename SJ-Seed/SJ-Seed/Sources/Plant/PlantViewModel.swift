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
    
    init(plant: PlantInfo = PlantInfo(
        name: "토마토",
        iconName: "sprout",              // ← 에셋 이름
        vitals: .init(temperature: 33, humidity: 65, soil: .dry)
    )) {
        self.plant = plant
    }
    
    var bubbleText: String {
        bubbleText(for: plant.vitals)
    }
    
    private func bubbleText(for v: PlantVitals) -> String {
        var parts: [String] = []
        if v.temperature >= 30 { parts.append("덥고") }
        if v.soil == .dry { parts.append("목말라요") }
        return parts.isEmpty ? "상태가 좋아요 🙂" : parts.joined(separator: " ") + "😣"
    }
}
