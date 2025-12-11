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
        // 질병명이 "정상"이 아닌 경우에만 질병 뷰를 띄움
        if let state = result.state, state != "정상" {
            DiseaseResultView(plant: plant, result: result)
        } else {
            // "정상"인 경우 건강 뷰
            HealthyResultView(plant: plant, result: result)
        }
    }
}
