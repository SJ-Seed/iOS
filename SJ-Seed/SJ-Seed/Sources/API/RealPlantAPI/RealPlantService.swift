//
//  RealPlantService.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/18/25.
//

import Foundation
import Moya

// MARK: - 서비스 객체
final class PlantService {
    
    static let shared = PlantService()
    private let provider = MoyaProvider<PlantAPI>()
    
    private init() {}
    
    // MARK: - 1. 식물 상세 정보 조회 (GET /plant/detail/{plantId})
    func getPlantDetail(plantId: Int, completion: @escaping (Result<PlantDetailResult, Error>) -> Void) {
        provider.request(.getPlantDetail(plantId: plantId)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. 공통 래퍼(APIResponse)로 디코딩
                    let decoded = try JSONDecoder().decode(APIResponse<PlantDetailResult>.self, from: response.data)
                    // 2. 'result' 내부의 PlantDetailResult를 전달
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 식물 상세 응답 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 식물 상세 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 2. 물 주기 필요 여부 조회 (GET /plant/ifNeedWater/{plantId})
    func checkIfNeedWater(plantId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.checkIfNeedWater(plantId: plantId)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. 공통 래퍼(APIResponse)로 디코딩 (result가 Bool 타입)
                    let decoded = try JSONDecoder().decode(APIResponse<Bool>.self, from: response.data)
                    // 2. 'result' 내부의 Bool 값을 전달
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 물주기 필요 응답 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 물주기 필요 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 3. 내 식물 상태 목록 조회 (GET /member/plants/{memberId})
    func getMemberPlants(memberId: Int, completion: @escaping (Result<[MemberPlantResult], Error>) -> Void) {
        provider.request(.getMemberPlants(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. 공통 래퍼(APIResponse)로 디코딩 (result가 [MemberPlantResult] 타입)
                    let decoded = try JSONDecoder().decode(APIResponse<[MemberPlantResult]>.self, from: response.data)
                    // 2. 'result' 내부의 배열을 전달
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 내 식물 상태 목록 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 내 식물 상태 목록 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }

    // MARK: - 4. 오늘 물 주기 여부 확인 (GET /plant/ifWatered/{plantId})
    func checkIfWatered(plantId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.checkIfWatered(plantId: plantId)) { result in
            switch result {
            case .success(let response):
                let responseString = String(data: response.data, encoding: .utf8) ?? "데이터 없음"
                print("📄 [물주기확인] ID: \(plantId) | 상태코드: \(response.statusCode)")
                print("📄 [물주기확인] 응답 데이터: \(responseString)")
                do {
                    // 여기서 APIResponse<Bool>.self 로 디코딩합니다.
                    let decoded = try JSONDecoder().decode(APIResponse<Bool>.self, from: response.data)
                    
                    // decoded.result는 true 또는 false가 됩니다.
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 오늘 물 주기 여부 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 오늘 물 주기 여부 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
}
