//
//  PlantStateViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/25/25.
//

import Foundation
import SwiftUI
import Combine

final class PlantStateViewModel: ObservableObject {
    let plantId: Int
    @Published var plant: PlantHomeInfo
    @Published var statusMessage: String          // ← 서버/로직에서 그대로 주는 문자열
    @Published var shouldWater: Bool              // ← 물주기 필요 여부
    
    private let plantService = PlantService.shared
    private var pollingTimer: AnyCancellable?
    private var pollingCount = 0
    private let maxPollingCount = 4 // 20초 / 5초 = 4회

    var onWateringSuccess: (() -> Void)?
    
    init(
        plantId: Int = 0,
        plant: PlantHomeInfo? = nil,
        statusMessage: String = "",
        shouldWater: Bool? = nil
    ) {
        // 기본값 설정 (초기 화면용 등)
        let defaultPlant = PlantHomeInfo(
            plantProfile: PlantProfile(
                id: UUID(),
                name: "",
                iconName: ""
            ),
            vitals: PlantVitals(
                temperature: 0,
                humidity: 0,
                soil: .normal
            )
        )

        // 주입된 plant가 있으면 그것을 사용
        self.plantId = plantId
        self.plant = plant ?? defaultPlant
        self.statusMessage = statusMessage
        if let shouldWater {                      // 주입 우선
            self.shouldWater = shouldWater
        } else {
            self.shouldWater = (plant?.vitals.soil == .dry)   // 기본 휴리스틱
        }
    }
    
    // ‼️ 물주기 확인 시작 함수
    func startWateringCheck() {
        guard shouldWater else {
            print("ℹ️ 물이 필요하지 않은 상태입니다.")
            return
        }
        
        print("💧 물주기 확인 시작 (20초간 폴링)")
        pollingCount = 0
        
        // 5초 간격 타이머 시작
        pollingTimer = Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkIfWatered()
            }
    }
    
    private func checkIfWatered() {
        guard pollingCount < maxPollingCount else {
            print("⏱️ 물주기 확인 시간 초과 (20초 경과)")
            stopPolling()
            return
        }
        
        pollingCount += 1
        
        plantService.checkIfWatered(plantId: plantId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let isWatered):
                if isWatered {
                    print("✅ 물주기 감지됨! (true)")
                    self.stopPolling()
                    self.shouldWater = false // 상태 업데이트
                    self.statusMessage = "목이 축여졌어요! 💧"
                    
                    // ‼️ 성공 콜백 실행 (화면 이동 등)
                    self.onWateringSuccess?()
                    
                } else {
                    print("⏳ 아직 물을 주지 않음... (\(self.pollingCount)/\(self.maxPollingCount))")
                }
                
            case .failure(let error):
                print("❌ 물주기 확인 실패:", error)
            }
        }
    }
    
    private func stopPolling() {
        pollingTimer?.cancel()
        pollingTimer = nil
    }
}
