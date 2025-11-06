//
//  PlantLotteryViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/6/25.
//

import Foundation

final class PlantLotteryViewModel: ObservableObject {
    @Published var isAnimating = false
    @Published var showText = false
    @Published var resultName: String? = nil
//    @Published var resultPieceId: Int = 0
    
    private let service = CollectionService.shared
    private let memberId = 1 // 임시 하드코딩 (로그인 연동 후 교체)
    
    // 랜덤 뽑기 요청
    func drawPlant() {
        isAnimating = true
        showText = true
        resultName = nil
        
        // 3초 동안 애니메이션 후 결과 표시
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.fetchRandomPlant()
        }
    }
    
    private func fetchRandomPlant() {
        service.getRandom(memberId: memberId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    // 서버가 ifNotLose: false를 보내면, data.name은 nil
                    print("🌱 뽑기 결과 (ifNotLose):", data.ifNotLose)
                    
                    if let name = data.name, data.pieceId != nil {
                        self?.resultName = name
                        self?.isAnimating = false
                        self?.showText = false
                    } else { // 꽝인 경우 (ifNotLose가 false인 경우)
                        self?.resultName = "꽝"
                        self?.isAnimating = false
                        // TODO: 꽝일 때의 UI 처리 (예: 알림창)
                    }
                case .failure(let error):
                    print("❌ 랜덤 뽑기 실패:", error)
                    self?.resultName = nil
                    self?.isAnimating = false
                }
            }
        }
    }
}
