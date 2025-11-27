//
//  MyPlantResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/11/25.
//

import Foundation

// MARK: - 식물 등록 (POST /member/plant/{memberId})
struct RegisterPlantResult: Codable {
    let id: Int?
    let name: String
    let broughtDate: String
    let memberId: Int
//    let speciesId: Int
}

// MARK: - 식물 리스트 조회 (GET /member/plantList/{memberId})
struct PlantListItem: Codable, Identifiable {
    var id: Int { plantId }
    let plantId: Int
    let name: String
    let broughtDate: String
    let diseased: Bool
    let species: String
    let speciesId: Int
}
