//
//  MyPlantService.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/11/25.
//

import Foundation
import Moya

final class MyPlantService {
    static let shared = MyPlantService()
    private let provider = MoyaProvider<MyPlantAPI>()
    
    private init() {}
    
    // MARK: - 식물 등록 (POST /member/plant/{memberId})
    func registerPlant(memberId: Int, name: String, code: String, completion: @escaping (Result<RegisterPlantResult, Error>) -> Void) {
        provider.request(.registerPlant(memberId: memberId, name: name, code: code)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(APIResponse<RegisterPlantResult>.self, from: response.data)
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 식물 등록 응답 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 식물 등록 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 식물 리스트 조회 (GET /member/plantList/{memberId})
    func getPlantList(memberId: Int, completion: @escaping (Result<[PlantListItem], Error>) -> Void) {
        provider.request(.plantList(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(APIResponse<[PlantListItem]>.self, from: response.data)
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 식물 리스트 응답 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 식물 리스트 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
}
