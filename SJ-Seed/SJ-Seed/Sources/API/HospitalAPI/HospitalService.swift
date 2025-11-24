//
//  HospitalService.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/25/25.
//

import Foundation
import Moya

final class HospitalService {
    
    static let shared = HospitalService()
    private let provider = MoyaProvider<HospitalAPI>()
    
    private init() {}
    
    // MARK: - 1. 진료 보기 (POST /hospital/treat/{memberId}/{plantId})
    func treatPlant(memberId: Int, plantId: Int, imageUrl: String, completion: @escaping (Result<TreatmentResult, Error>) -> Void) {
        provider.request(.treat(memberId: memberId, plantId: plantId, imageUrl: imageUrl)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. APIResponse<TreatmentResult>로 디코딩
                    let decoded = try JSONDecoder().decode(APIResponse<TreatmentResult>.self, from: response.data)
                    // 2. result 반환
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 진료 요청 응답 디코딩 실패:", error)
                    // 디버깅용 로그
                    if let str = String(data: response.data, encoding: .utf8) {
                        print("📄 원본 데이터: \(str)")
                    }
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 진료 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 2. 진료 기록 조회 (GET /hospital/treatmentList/{memberId})
    func getTreatmentList(memberId: Int, completion: @escaping (Result<[TreatmentListItem], Error>) -> Void) {
        provider.request(.getTreatmentList(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. APIResponse<[TreatmentListItem]>로 디코딩
                    let decoded = try JSONDecoder().decode(APIResponse<[TreatmentListItem]>.self, from: response.data)
                    // 2. result 반환
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 진료 기록 목록 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 진료 기록 목록 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
}
