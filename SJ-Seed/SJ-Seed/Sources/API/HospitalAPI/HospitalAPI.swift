//
//  HospitalAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/25/25.
//

import Foundation
import Moya

enum HospitalAPI {
    // 1. 진료 보기 (POST /hospital/treat/{memberId}/{plantId})
    case treat(memberId: Int, plantId: Int, imageUrl: String)
    
    // 2. 진료 기록 조회 (GET /hospital/treatmentList/{memberId})
    case getTreatmentList(memberId: Int)
    
    // 3. 진료 기록 상세 조회 (GET /hospital/treatment/{treatmentId})
    case getTreatmentDetail(treatmentId: Int)
}

struct TreatRequestBody: Encodable {
    let url: String
}

extension HospitalAPI: TargetType {
    
    // 공통 Base URL
    var baseURL: URL {
        return URL(string: "https://sj-seed.com/api")!
    }
    
    // 엔드포인트 경로
    var path: String {
        switch self {
        case let .treat(memberId, plantId, _):
            return "/hospital/treat/\(memberId)/\(plantId)"
            
        case let .getTreatmentList(memberId):
            return "/hospital/treatmentList/\(memberId)"
            
        case let .getTreatmentDetail(treatmentId):
            return "/hospital/treatment/\(treatmentId)"
        }
    }
    
    // HTTP 메서드
    var method: Moya.Method {
        switch self {
        case .treat:
            return .post
        case .getTreatmentList, .getTreatmentDetail:
            return .get
        }
    }
    
    // 요청 작업 (Body 설정)
    var task: Task {
        switch self {
        case let .treat(_, _, imageUrl):
            // Body에 JSON 데이터 {"url": "..."} 실어 보내기
            let body = TreatRequestBody(url: imageUrl)
            return .requestJSONEncodable(body)
            
        case .getTreatmentList, .getTreatmentDetail:
            // GET 요청은 Body 없음
            return .requestPlain
        }
    }
    
    // 헤더 설정
    var headers: [String : String]? {
        return [
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AuthManager.shared.accessToken)"
        ]
    }
}
