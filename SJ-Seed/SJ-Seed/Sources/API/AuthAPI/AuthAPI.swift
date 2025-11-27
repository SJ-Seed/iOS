//
//  AuthAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation
import Moya

enum AuthAPI {
    case signUp(request: SignUpRequest)
    case signIn(request: SignInRequest)
}

extension AuthAPI: TargetType {
    
    // 1. 공통 BaseURL
    var baseURL: URL {
        return URL(string: "https://sj-seed.com/api")!
    }
    
    // 2. 엔드포인트 Path
    var path: String {
        switch self {
        case .signUp:
            return "/member/signup"
        case .signIn:
            return "/member/signin"
        }
    }
    
    // 3. HTTP Method
    var method: Moya.Method {
        switch self {
        case .signUp, .signIn:
            return .post
        }
    }
    
    // 4. Task (JSON Body 설정)
    var task: Task {
        switch self {
        case .signUp(let request):
            return .requestJSONEncodable(request)
            
        case .signIn(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    // 5. 헤더
    var headers: [String : String]? {
        return [
            "accept": "*/*",
            "Content-Type": "application/json"
        ]
    }
}
