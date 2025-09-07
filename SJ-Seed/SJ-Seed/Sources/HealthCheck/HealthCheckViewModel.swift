//
//  HealthCheckViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/8/25.
//

import Foundation

final class HealthCheckViewModel: ObservableObject {
    @Published var model: HealthCheckModel?
    @Published var errorMessage: String?

    private let service: HealthService

    init(service: HealthService = HealthService()) {
        self.service = service
    }

    func check() {
        service.getHealthCheck { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.model = HealthCheckModel(status: response.status)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
