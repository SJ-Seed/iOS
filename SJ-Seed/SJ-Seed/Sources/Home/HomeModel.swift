//
//  HomeModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/23/25.
//

import Foundation

struct Attendance {
    let weekday: Weekday
    var isChecked: Bool
}

enum Weekday: Int, CaseIterable {
    case sun = 0, mon, tue, wed, thu, fri, sat
    
    var symbol: String {
        switch self {
        case .sun: return "일"
        case .mon: return "월"
        case .tue: return "화"
        case .wed: return "수"
        case .thu: return "목"
        case .fri: return "금"
        case .sat: return "토"
        }
    }
}
