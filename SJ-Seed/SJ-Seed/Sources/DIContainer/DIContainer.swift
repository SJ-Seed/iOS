//
//  DIContainer.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/6/25.
//

import SwiftUI
import Combine
import Moya
import Foundation

final class DIContainer: ObservableObject {
    // MARK: - Router
    var router: AppRouter
    
    // MARK: - Services
//    let authService: AuthService
//    let collectionService: CollectionService
    
    // MARK: - Published Properties
    @Published var selectedTab: String = "홈"
    
    init(router: AppRouter) {
        self.router = router
        
        // 서비스 초기화
//        self.authService = AuthService()
//        self.collectionService = CollectionService.shared
    }
}

// MARK: - EnvironmentKey 등록
private struct DIContainerKey: EnvironmentKey {
    static var defaultValue: DIContainer = DIContainer(router: AppRouter())
}

extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
