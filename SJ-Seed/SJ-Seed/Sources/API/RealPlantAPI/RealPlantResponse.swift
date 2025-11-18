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
