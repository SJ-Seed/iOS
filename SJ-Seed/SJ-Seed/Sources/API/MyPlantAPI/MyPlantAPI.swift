//
//  MyPlantAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/11/25.
//

import Foundation
import Moya

enum MyPlantAPI {
    case registerPlant(memberId: Int, name: String, code: String)
    case plantList(memberId: Int)
}

struct RegisterPlantBody: Encodable {
    let name: String
    let code: String
}

extension MyPlantAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://sj-seed.com/api")!
    }
    
    var path: String {
        switch self {
        case let .registerPlant(memberId, _, _):
            return "/member/plant/\(memberId)"
        case let .plantList(memberId):
            return "/member/plantList/\(memberId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerPlant:
            return .post
        case .plantList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .registerPlant(_, name, code):
            let body = RegisterPlantBody(name: name, code: code)
            return .requestJSONEncodable(body)
            
        case .plantList:
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
