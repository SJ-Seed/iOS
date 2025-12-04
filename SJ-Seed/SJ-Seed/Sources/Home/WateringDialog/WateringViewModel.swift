//
//  WateringViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/20/25.
//

import Foundation
import Combine

enum WateringStep {
    case instruction // 안내 화면 (LetsWaterView 내용)
    case checking    // 확인 중 (CheckWateringView)
    case complete    // 완료 (CompleteWateringView)
    case failure     // 실패 (시간 초과 등)
}

@MainActor
final class WateringViewModel: ObservableObject {
    let plantId: Int
    @Published var currentStep: WateringStep = .instruction
    @Published var errorMessage: String? = nil
    
    private let service = PlantService.shared
    private var pollingTimer: AnyCancellable?
    private var pollingCount = 0
    private let maxPollingCount = 4 // 20초 / 5초 = 4회
    
    init(plantId: Int) {
        self.plantId = plantId
    }
    
    // 물주기 확인 시작 (Step 1 -> Step 2)
    func startWateringCheck() {
        self.currentStep = .checking
        self.pollingCount = 0
        self.errorMessage = nil
        
        print("💧 물주기 확인 시작 (ID: \(plantId))")
        
        // 즉시 한 번 체크하고 타이머 시작 !!!!->원래 코드 (데모에서는 주석처리)
//        checkIfWatered()
//        
//        pollingTimer = Timer.publish(every: 5.0, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                self?.checkIfWatered()
//            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            print("✅ [데모 모드] 10초 경과 -> 물주기 성공 처리!")
            self?.stopPolling()
            self?.currentStep = .complete
        }
    }
    
    private func checkIfWatered() {
        guard pollingCount < maxPollingCount else {
            print("⏱️ 물주기 확인 시간 초과")
            stopPolling()
            self.currentStep = .failure // 혹은 instruction으로 되돌리고 에러 메시지
            self.errorMessage = "물을 감지하지 못했어요.\n조금 더 기다려보거나 다시 시도해주세요."
            return
        }
        
        pollingCount += 1
        
        service.checkIfWatered(plantId: plantId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let isWatered):
                if isWatered {
                    print("✅ 물주기 성공!")
                    self.stopPolling()
                    self.currentStep = .complete // 성공 화면으로 전환
                } else {
                    print("⏳ 확인 중... (\(self.pollingCount)/\(self.maxPollingCount))")
                }
            case .failure(let error):
                print("❌ API 호출 실패:", error)
            }
        }
    }
    
    private func stopPolling() {
        pollingTimer?.cancel()
        pollingTimer = nil
    }
    
    func resetState() {
        stopPolling()
        currentStep = .instruction
        errorMessage = nil
    }
}
