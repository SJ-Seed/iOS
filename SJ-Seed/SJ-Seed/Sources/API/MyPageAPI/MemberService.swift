//
//  MemberService.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import Foundation
import Moya

final class MemberService {
    
    static let shared = MemberService()
    private let provider = MoyaProvider<MemberAPI>()
    
    private init() {}
    
    // MARK: - 회원 상세 정보 조회 (GET /member/detail/{memberId})
    func getMemberDetail(memberId: Int, completion: @escaping (Result<MemberDetailResult, Error>) -> Void) {
        provider.request(.getMemberDetail(memberId: memberId)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. 공통 래퍼(APIResponse)로 디코딩
                    let decoded = try JSONDecoder().decode(APIResponse<MemberDetailResult>.self, from: response.data)
                    
                    // 2. result(MemberDetailResult) 반환
                    completion(.success(decoded.result))
                    
                } catch {
                    print("❌ 회원 정보 디코딩 실패:", error)
                    
                    // 디버깅용 로그
                    if let str = String(data: response.data, encoding: .utf8) {
                        print("📄 원본 데이터: \(str)")
                    }
                    
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 회원 정보 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
}