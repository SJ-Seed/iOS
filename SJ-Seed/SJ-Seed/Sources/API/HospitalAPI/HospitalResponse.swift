//
//  HospitalResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/25/25.
//

import Foundation

// MARK: - 1. 진료 결과 (POST /hospital/treat/...)
struct TreatmentResult: Codable, Hashable {
    let photo: Bool
    let state: String?
    let message: String?
    let explain: String?
    let cause: String?
    let cure: String?
}

// MARK: - 2. 진료 기록 목록 (GET /hospital/treatmentList/...)
struct TreatmentListItem: Codable, Identifiable {
    let id = UUID() // List/ForEach 사용을 위해 추가 (API에는 없음)
    
    let plantName: String
    let date: String
    let disease: String? // 질병이 없거나(null) 식별 불가일 수 있음
    
    let plantId: Int
    let speciesId: Int
    
    // CodingKeys를 사용하여 id는 디코딩에서 제외
    enum CodingKeys: String, CodingKey {
        case plantName
        case date
        case disease
        case plantId
        case speciesId
    }
}
