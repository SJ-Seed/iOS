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
    init() {}
    
    private let provider = MoyaProvider<AuthAPI>()
    
    /// 로그인 요청
    func login(loginId: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        provider.request(.signin(loginId: loginId, password: password)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let loginResponse = try decoder.decode(LoginResponse.self, from: response.data)
                    
                    if loginResponse.isSuccess {
                        print("✅ 로그인 성공: \(loginResponse.result.name)")
                        
                        // 토큰 저장 (필요 시)
                        UserDefaults.standard.set(loginResponse.result.token, forKey: "accessToken")
                        
                        completion(.success(loginResponse))
                    } else {
                        print("⚠️ 로그인 실패: \(loginResponse.message)")
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: loginResponse.message])
                        completion(.failure(error))
                    }
                } catch {
                    print("❌ 디코딩 실패: \(error)")
                    completion(.failure(error))
                }
                
            case .failure(let error):
                print("❌ 네트워크 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
}
