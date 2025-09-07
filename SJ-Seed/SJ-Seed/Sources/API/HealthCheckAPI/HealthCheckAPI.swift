//
//  HealthCheckAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/8/25.
//

import Foundation
import Moya

// 1) Router 정의
enum HealthAPI: TargetType {
    case health
}

extension HealthAPI {
    var baseURL: URL { URL(string: "https://sj-seed.com")! }
    var path: String {
        switch self {
        case .health: return "/health"
        }
    }
    var method: Moya.Method {
        switch self {
        case .health: return .get
        }
    }
    var task: Task {
        // 쿼리/바디 없음
        .requestPlain
    }
    var headers: [String : String]? {
        // 필요한 최소 헤더만. (없어도 보통 OK)
        ["Accept": "*/*"]
    }
    var sampleData: Data {
        // 유닛테스트/스텁용
        "ok".data(using: .utf8) ?? Data()
    }
}
