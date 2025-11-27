//
//  SJ_SeedApp.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/1/25.
//

import SwiftUI

@main
struct SJ_SeedApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var container: DIContainer
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        let router = AppRouter()
        self._router = StateObject(wrappedValue: router)
        self._container = StateObject(wrappedValue: DIContainer(router: router))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                HomeView() // 시작 화면 수정 필요
                
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .login:
                            let _ = print("로그인뷰나중에구현할게")
//                            LoginView()
                        case .home:
                            HomeView()
                                .navigationBarBackButtonHidden(true)
                        case .hospital:
                            HospitalView()
                                .navigationBarBackButtonHidden(true)
                        case .diagnosisResult(let plantProfile, let treatmentResult):
                            DiagnosisResultView(plant: plantProfile, result: treatmentResult)
                                .navigationBarBackButtonHidden(true)
                        case .diagnosisList:
                            DiagnosisListView()
                                .navigationBarBackButtonHidden(true)
                        case .myPlant:
                            PlantListView()
                                .navigationBarBackButtonHidden(true)
                        case .letsWater(let plantId):
                            LetsWaterView(plantId: plantId)
                                .navigationBarBackButtonHidden(true)
                        case .myPlantDetail(let plantId):
                            MyPlantDetailView(plantId: plantId)
                                .navigationBarBackButtonHidden(true)
                        case .plantRegister:
                            PlantRegisterView()
                                .navigationBarBackButtonHidden(true)
                        case .plantBookList:
                            PlantBookListView()
                                .navigationBarBackButtonHidden(true)
                        case .plantDetail(let speciesId):
                            PlantDetailView(speciesId: speciesId)
                                .navigationBarBackButtonHidden(true)
                        case .plantLottery:
                            PlantLotteryView()
                                .navigationBarBackButtonHidden(true)
                        }
                    }
            }
            .environmentObject(container)
            .environment(\.diContainer, container)
            .alert(isPresented: $container.router.showAlert) {
                Alert(
                    title: Text("알림"),
                    message: Text(container.router.alertMessage),
                    dismissButton: .default(Text("확인")) {
                        container.router.alertAction?()
                        container.router.alertAction = nil
                    }
                )
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                // 토큰 만료 체크나 자동 로그인 등 관리 가능
                print("🌱 App 활성화됨")
            }
        }
    }
}
