//
//  AppRouter.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/6/25.
//

import SwiftUI

enum Route: Hashable {
    case login
    case home
    case hospital
    case plantBook
    case plantDetail(pieceId: Int, plantName: String)
    case lottery
}

final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    var alertAction: (() -> Void)? = nil
    
    // MARK: - Navigation Methods
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty { path.removeLast() }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func reset() {
        path = NavigationPath()
    }
}
