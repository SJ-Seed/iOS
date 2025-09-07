//
//  HealthCheckResponse.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/8/25.
//

import Foundation
import Moya

struct HealthResponse {
    let status: String
}

extension HealthResponse {
    init(from response: Moya.Response) throws {
        // 단순 문자열 응답 → UTF8 String 변환
        guard let text = String(data: response.data, encoding: .utf8) else {
            throw MoyaError.stringMapping(response)
        }
        self.status = text
    }
}
