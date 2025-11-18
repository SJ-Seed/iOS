//
//  HomeModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/23/25.
//

import Foundation
import SwiftUI

// MARK: - 요일
enum Weekday: Int, CaseIterable, Codable {
    case mon = 0, tue, wed, thu, fri, sat, sun
    
    var symbol: String {
        switch self {
        case .mon: return "월"
        case .tue: return "화"
        case .wed: return "수"
        case .thu: return "목"
        case .fri: return "금"
        case .sat: return "토"
        case .sun: return "일"
        }
    }
}

// MARK: - 출석(하루)
struct AttendanceDay: Identifiable, Equatable, Codable {
    let weekday: Weekday
    var isChecked: Bool
    var id: Weekday { weekday }
}

// MARK: - 출석(주간) + 오늘 코인
struct WeeklyAttendance: Equatable, Codable {
    var days: [AttendanceDay]
    var todayRewardCoin: Int
    
    init(days: [AttendanceDay] = Weekday.allCases.map { .init(weekday: $0, isChecked: false) },
         todayRewardCoin: Int = 0) {
        self.days = days
        self.todayRewardCoin = todayRewardCoin
    }
}
