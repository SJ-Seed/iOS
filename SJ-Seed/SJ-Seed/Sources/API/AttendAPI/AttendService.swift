//
//  AttendService.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/18/25.
//

import Foundation
import Moya

// MARK: - 서비스 객체
final class AttendService {
    
    static let shared = AttendService()
    private let provider = MoyaProvider<AttendAPI>()
    
    private init() {}
    
    // MARK: - 1. 출석 정보 조회 (GET /member/attend/{memberId})
    func getAttendance(memberId: Int, completion: @escaping (Result<[Bool], Error>) -> Void) {
        provider.request(.getAttendance(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                // (디버깅 로그는 여기에 있었음)
                do {
                    // ‼️ APIResponse<[Bool]>.self로 디코딩
                    let decoded = try JSONDecoder().decode(APIResponse<[Bool]>.self, from: response.data)
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 출석 정보 응답 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 출석 정보 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 2. 출석 체크 (PATCH /member/attend/{memberId})
    func checkIn(memberId: Int, completion: @escaping (Result<AttendanceResult, Error>) -> Void) {
        provider.request(.checkIn(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                do {
                    // ‼️ APIResponse<AttendanceResult>.self로 디코딩
                    let decoded = try JSONDecoder().decode(APIResponse<AttendanceResult>.self, from: response.data)
                    completion(.success(decoded.result))
                } catch {
                    print("❌ 출석 체크 응답 디코딩 실패:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 출석 체크 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
}
