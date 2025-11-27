//
//  MemberAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import Foundation
import Moya

enum MemberAPI {
    case getMemberDetail(memberId: Int)
    case getCoin(memberId: Int)
}

extension MemberAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://sj-seed.com/api")!
    }
    
    var path: String {
        switch self {
        case .getMemberDetail(let memberId):
            return "/member/detail/\(memberId)"
        case .getCoin(let memberId):
            return "/member/coin/\(memberId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMemberDetail, .getCoin:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getMemberDetail, .getCoin:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AuthManager.shared.accessToken)"
        ]
    }
}
