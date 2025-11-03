//
//  CollectionService.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation
import Moya

final class CollectionService {
    static let shared = CollectionService()
    private let provider = MoyaProvider<CollectionAPI>()
    private init() {}
    
    // MARK: - 랜덤 뽑기 API (POST /collection/random/{memberId})
    func fetchRandom(memberId: Int, completion: @escaping (Result<IfNotLoseResult, Error>) -> Void) {
        provider.request(.random(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(APIResponse<IfNotLoseResult>.self, from: response.data)
                    if decoded.isSuccess {
                        completion(.success(decoded.result))
                    } else {
                        let error = NSError(domain: "CollectionService", code: -1, userInfo: [NSLocalizedDescriptionKey: decoded.message])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 조각 리스트 조회 API (GET /collection/pieceList/{memberId})
    func fetchPieceList(memberId: Int, completion: @escaping (Result<[ItemResult], Error>) -> Void) {
        provider.request(.pieceList(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(APIResponse<[ItemResult]>.self, from: response.data)
                    if decoded.isSuccess {
                        completion(.success(decoded.result))
                    } else {
                        let error = NSError(domain: "CollectionService", code: -1, userInfo: [NSLocalizedDescriptionKey: decoded.message])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
