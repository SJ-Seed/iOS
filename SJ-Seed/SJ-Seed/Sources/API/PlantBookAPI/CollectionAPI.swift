//
//  CollectionAPI.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/4/25.
//

import Foundation
import Moya

enum CollectionAPI {
    case random(memberId: Int)
    case pieceList(memberId: Int)
    case piece(speciesId: Int)
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
        case let .piece(speciesId):
            return "/collection/piece/\(speciesId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .random:
            return .post
        case .pieceList, .piece:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .random, .pieceList, .piece:
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
