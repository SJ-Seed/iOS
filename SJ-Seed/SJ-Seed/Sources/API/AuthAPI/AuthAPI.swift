//
//  AuthAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation
import Moya

enum AuthAPI {
    case signin(loginId: String, password: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://sj-seed.com/api")!
    }
    
    var path: String {
        switch self {
        case .signin:
            return "/member/signin"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .signin(loginId, password):
            let parameters: [String: Any] = [
                "loginId": loginId,
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "*/*"
        ]
    }
}
