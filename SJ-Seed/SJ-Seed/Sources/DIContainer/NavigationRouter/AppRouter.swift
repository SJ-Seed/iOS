//
//  AppRouter.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/6/25.
//

import SwiftUI

enum Route: Hashable {
    case loginMain
    case loginInput
    case signUp
    case myPage
    case home
    case hospital
    case diagnosisResult(plant: PlantProfile, result: TreatmentResult)
    case diagnosisList
    case myPlant
    case letsWater(plantId: Int)
    case myPlantDetail(plantId: Int)
    case plantRegister
    case plantBookList
    case plantDetail(speciesId: Int)
    case plantLottery
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
