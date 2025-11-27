//
//  AuthService.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation
import Moya

final class AuthService {
    
    static let shared = AuthService()
    private let provider = MoyaProvider<AuthAPI>()
    
    private init() {}
    
    // MARK: - 회원가입 (POST /member/signup)
    func signUp(request: SignUpRequest, completion: @escaping (Result<SignUpResult, Error>) -> Void) {
        provider.request(.signUp(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. 공통 래퍼(APIResponse)로 디코딩
                    let decoded = try JSONDecoder().decode(APIResponse<SignUpResult>.self, from: response.data)
                    
                    // 2. 성공 결과 반환
                    completion(.success(decoded.result))
                    
                } catch {
                    print("❌ 회원가입 응답 디코딩 실패:", error)
                    // 디버깅용
                    if let str = String(data: response.data, encoding: .utf8) {
                        print("📄 원본 데이터: \(str)")
                    }
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 회원가입 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 로그인 (POST /member/signin)
    func signIn(request: SignInRequest, completion: @escaping (Result<SignInResult, Error>) -> Void) {
        provider.request(.signIn(request: request)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. 공통 래퍼(APIResponse)로 디코딩
                    let decoded = try JSONDecoder().decode(APIResponse<SignInResult>.self, from: response.data)
                    let resultData = decoded.result
                    
                    // ‼️ [중요] 2. 로그인 성공 후 토큰 저장
                    AuthManager.shared.accessToken = resultData.token
                    print("✅ Access Token 저장 완료")
                    
                    // ‼️ [중요] 3. memberId 저장 (String -> Int 변환)
                    if let memberIdInt = Int(resultData.memberId) {
                        AuthManager.shared.currentMemberId = memberIdInt // AuthManager에 저장
                        print("✅ 로그인 성공! Member ID 저장 완료: \(memberIdInt)")
                    }
                    
                    // 4. 성공 결과 반환
                    completion(.success(resultData))
                    
                } catch {
                    print("❌ 로그인 응답 디코딩 실패:", error)
                    if let str = String(data: response.data, encoding: .utf8) {
                        print("📄 원본 데이터: \(str)")
                    }
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 로그인 요청 실패:", error)
                completion(.failure(error))
            }
        }
    }
}
