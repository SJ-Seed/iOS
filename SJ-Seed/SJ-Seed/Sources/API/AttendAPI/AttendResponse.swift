//
//  AttendResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/18/25.
//

import Foundation

struct AttendanceResult: Codable {
    let attendedDays: [Bool]
    let rewardedCoin: Int
    let totalCoin: Int
}
