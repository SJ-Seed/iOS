//
//  RealPlantResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/18/25.
//

import Foundation

struct PlantDetailResult: Codable {
    let name: String
    let species: String
    let broughtDate: String
    let description: String
    let properTemp: String
    let properHum: String
    let water: String
}

// MARK: - 내 식물 상태 목록 조회 (GET /member/plants/{memberId})
struct MemberPlantResult: Codable, Identifiable {
    let plantId: Int
    let name: String
    let temperature: Double // 센서 값은 소수점일 수 있으므로 Double 추천
    let humidity: Double
    let soilWater: Double   // 0~100 사이의 수분량일 것으로 추정
    let speciesId: Int?
    
    // Identifiable 채택 (ForEach에서 사용하기 위함)
    var id: Int { plantId }
}
