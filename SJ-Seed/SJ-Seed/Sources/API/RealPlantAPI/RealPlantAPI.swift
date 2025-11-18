//
//  RealPlantAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/18/25.
//

import Foundation
import Moya

// 1. 'plantId'를 사용하는 두 개의 API 엔드포인트를 정의합니다.
enum PlantAPI {
    case getPlantDetail(plantId: Int)
    case checkIfNeedWater(plantId: Int)
}

extension PlantAPI: TargetType {
    
    // 2. 공통 BaseURL
    var baseURL: URL {
        return URL(string: "https://sj-seed.com/api")!
    }
    
    // 3. 엔드포인트별 Path
    var path: String {
        switch self {
        case .getPlantDetail(let plantId):
            return "/plant/detail/\(plantId)"
        case .checkIfNeedWater(let plantId):
            return "/plant/ifNeedWater/\(plantId)"
        }
    }
    
    // 4. 두 API 모두 GET 방식
    var method: Moya.Method {
        switch self {
        case .getPlantDetail, .checkIfNeedWater:
            return .get
        }
    }
    
    // 5. 요청 본문(body)이 없는 'requestPlain'
    var task: Task {
        switch self {
        case .getPlantDetail, .checkIfNeedWater:
            return .requestPlain
        }
    }
    
    // 6. 필수 헤더 (AuthManager는 기존 코드 참고)
    var headers: [String : String]? {
        return [
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AuthManager.shared.accessToken)"
        ]
    }
}
