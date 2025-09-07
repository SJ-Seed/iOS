//
//  HealthCheckModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/8/25.
//

import Foundation
import Moya

struct HealthCheckModel: Codable {
    var status: String
    
    init(status: String) {
        self.status = status
    }
    
    init(from response: Moya.Response) {
        let text = String(data: response.data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.status = text
    }
}
