//
//  HealthCheckService.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/8/25.
//

import Foundation
import Moya

final class HealthService {
    private let provider: MoyaProvider<HealthAPI>
    
    init(provider: MoyaProvider<HealthAPI> = MoyaProvider<HealthAPI>()) {
        self.provider = provider
    }
    
//    func checkHealth() async throws -> HealthResponse {
//        let response = try await provider.async.request(.health)
//        return try HealthResponse(from: response)
//    }
//    
    
    func getHealthCheck(completion: @escaping (Result<HealthResponse, Error>) -> Void) {
        provider.request(.health) { result in
            switch result {
            case .success(let response):
                do {
                    let healthResponse = try HealthResponse(from: response)
                    completion(.success(healthResponse))
                } catch {
                    completion(.failure(error))
                }
                print("HealthCheck Response Code: \(response.statusCode)")
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
