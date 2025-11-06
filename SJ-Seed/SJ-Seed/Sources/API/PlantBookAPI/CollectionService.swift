//
//  CollectionService.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/4/25.
//

import Foundation
import Moya

final class CollectionService {
    static let shared = CollectionService()
    private let provider = MoyaProvider<CollectionAPI>()
    
    init() {}
    
    // MARK: - 1. 랜덤 뽑기
    func getRandom(memberId: Int, completion: @escaping (Result<RandomResult, Error>) -> Void) {
        provider.request(.random(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                if let responseString = String(data: response.data, encoding: .utf8) {
                    print("📄 랜덤 뽑기 원본 데이터: \(responseString)")
                }
                do {
                    let decoded = try JSONDecoder().decode(APIResponse<RandomResult>.self, from: response.data)
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 랜덤 응답 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 랜덤 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 2. 조각 리스트 조회
    func getPieceList(memberId: Int, completion: @escaping (Result<[PieceListItem], Error>) -> Void) {
        provider.request(.pieceList(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(APIResponse<[PieceListItem]>.self, from: response.data)
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 조각 리스트 응답 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 조각 리스트 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 3. 조각 상세 정보 조회
    func getPieceDetail(speciesId: Int, completion: @escaping (Result<PieceDetail, Error>) -> Void) {
        provider.request(.piece(speciesId: speciesId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(APIResponse<PieceDetail>.self, from: response.data)
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 조각 상세 응답 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 조각 상세 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
}
