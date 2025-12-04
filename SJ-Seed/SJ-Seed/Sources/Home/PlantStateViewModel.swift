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
    @Published var statusMessage: String
    @Published var shouldWater: Bool // 물주기 필요 여부
    
    @Published var isWateringButtonDisabled: Bool = false
    
    private var storageKey: String {
        "watered_status_\(plant.plantProfile.id.uuidString)"
    }
    
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
        
        if let shouldWater {                      // 주입 우선
            self.shouldWater = shouldWater
        } else {
            self.shouldWater = (plant?.vitals.soil == .dry)   // 기본 휴리스틱
        }
        
        self.statusMessage = statusMessage
        
        self.statusMessage = self.getConditionMessage(
            temp: self.plant.vitals.temperature,
            hum: self.plant.vitals.humidity
        )
        checkLocalStatus()
    }
    
    // 로컬 저장소 확인
    func checkLocalStatus() {
        // UserDefaults에 true라고 저장되어 있다면 물을 준 상태임
        let isAlreadyWatered = UserDefaults.standard.bool(forKey: storageKey)
        
        if isAlreadyWatered {
            print("🔒 [로컬] 이미 물을 준 기록이 있습니다.")
            self.shouldWater = false
            self.isWateringButtonDisabled = true
        }
    }
    
    // [핵심] 물주기 버튼 눌렀을 때 호출할 함수
    func markAsWatered() {
        print("💧 [로컬] 물주기 완료 처리 -> 저장소에 기록")
        
        // 1. UserDefaults에 'true' 저장 (영구 저장)
        UserDefaults.standard.set(true, forKey: storageKey)
        
        // 2. 화면 즉시 갱신
        self.shouldWater = false
        self.isWateringButtonDisabled = true
    }
    
    // MARK: - 온습도 상태 메시지 결정 로직
    private func getConditionMessage(temp: Double, hum: Double) -> String {
        // 기준 범위
        let minTemp: Double = 20
        let maxTemp: Double = 27
        let minHum: Double = 50
        let maxHum: Double = 70
        
        // 온도 상태 (0: 낮음, 1: 적당, 2: 높음)
        let tempState: Int
        if temp < minTemp { tempState = 0 }
        else if temp > maxTemp { tempState = 2 }
        else { tempState = 1 }
        
        // 습도 상태 (0: 낮음, 1: 적당, 2: 높음)
        let humState: Int
        if hum < minHum { humState = 0 }
        else if hum > maxHum { humState = 2 }
        else { humState = 1 }
        
        // 조합에 따른 메시지 반환
        switch (tempState, humState) {
        case (2, 2): // 고온 고습
            return "덥고 습해... 호흡이 힘들고, 곰팡이가 무섭다 ㅠㅠ 바람이 불면 좋겠어🥲"
        case (2, 1): // 고온 적습
            return "덥다!! 수분이 날라가는 것 같아. 시원한 곳에 가고 싶어😣"
        case (2, 0): // 고온 저습
            return "오늘 공기는 뜨겁고 메말라서 마치 사막에 있는 것 같아🤔 내가 타는 느낌이야"
            
        case (1, 2): // 적온 고습
            return "공기가 너무 축축해서 숨쉬기 힘들어... 바람이 좀 불었으면 좋겠어😟"
        case (1, 1): // 적온 적습
            return "완벽한 날이야! 기분 좋다😆"
        case (1, 0): // 적온 저습
            return "공기가 좀 건조하네... 주변에 분무기라도 뿌려줘🥺"
            
        case (0, 2): // 저온 고습
            return "추운데 습하기까지해서 뿌리랑 잎이 상할 것 같아😵"
        case (0, 1): // 저온 적습
            return "따뜻한 햇살이 있으면 좋을텐데🥶 성장이 느려진 것 같아"
        case (0, 0): // 저온 저습
            return "춥고 건조해서 잎이 마르는 것 같아😭 시들면 어떡하지? 따뜻한 곳으로 가고 싶어"
            
        default:
            return "상태를 확인하고 있어요..."
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
                    
                    self.isWateringButtonDisabled = true
                    
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
