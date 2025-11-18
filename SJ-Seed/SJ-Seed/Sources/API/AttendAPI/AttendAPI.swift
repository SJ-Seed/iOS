//
//  AttendAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/18/25.
//

import Foundation
import Moya

// 'memberId'를 사용하는 출석(attend) API 라우터입니다.
enum AttendAPI {
    case getAttendance(memberId: Int)  // 출석 정보 조회 (GET)
    case checkIn(memberId: Int)        // 출석 체크 (PATCH)
}

extension AttendAPI: TargetType {
    
    // 1. 공통 BaseURL
    var baseURL: URL {
        return URL(string: "https://sj-seed.com/api")!
    }
    
    // 2. 엔드포인트별 Path
    var path: String {
        switch self {
        // 두 케이스 모두 동일한 URL을 사용합니다.
        case .getAttendance(let memberId):
            return "/member/attend/\(memberId)"
        case .checkIn(let memberId):
            return "/member/attend/\(memberId)"
        }
    }
    
    // 3. HTTP Method (GET / PATCH)
    var method: Moya.Method {
        switch self {
        case .getAttendance:
            return .get   // 👈 첫 번째 요청
        case .checkIn:
            return .patch // 👈 두 번째 요청
        }
    }
    
    // 4. Task (요청 본문 없음)
    var task: Task {
        switch self {
        case .getAttendance, .checkIn:
            return .requestPlain
        }
    }
    
    // 5. 필수 헤더 (AuthManager는 기존 코드 참고)
    var headers: [String : String]? {
        // 브라우저 헤더(sec-*, user-agent, referer 등)는 제외
        return [
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AuthManager.shared.accessToken)"
        ]
    }
}
