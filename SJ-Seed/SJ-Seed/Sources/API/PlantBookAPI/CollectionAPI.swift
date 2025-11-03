//
//  CollectionAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation
import Moya

enum CollectionAPI {
    case random(memberId: Int)
    case pieceList(memberId: Int)
}

extension CollectionAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://sj-seed.com/api")!
    }
    
    var path: String {
        switch self {
        case let .random(memberId):
            return "/collection/random/\(memberId)"
        case let .pieceList(memberId):
            return "/collection/pieceList/\(memberId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .random:
            return .post
        case .pieceList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .random, .pieceList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer \(AuthManager.shared.accessToken)"
        ]
    }
}
