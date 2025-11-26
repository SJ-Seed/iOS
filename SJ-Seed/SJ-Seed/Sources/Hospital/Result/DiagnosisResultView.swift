//
//  DiagnosisResultView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/25/25.
//

import SwiftUI

struct DiagnosisResultView: View {
    let plant: PlantProfile      // 식물 아이콘/이름 표시용
    let result: TreatmentResult  // API 응답 데이터
    
    var body: some View {
        // 분기 로직: 치료법(cure)이나 원인(cause)이 있으면 '질병', 없으면 '건강'으로 간주
        if let cure = result.cure, !cure.isEmpty {
            DiseaseResultView(plant: plant, result: result)
        } else {
            HealthyResultView(plant: plant, result: result)
        }
    }
}
