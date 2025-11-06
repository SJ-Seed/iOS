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
//                    print("🌱 뽑힌 식물: \(data.name)")
//                    self?.resultName = data.name
                    // 서버가 ifNotLose: false를 보내면, data.name은 nil입니다.
                    print("🌱 뽑기 결과 (ifNotLose):", data.ifNotLose)
                    
                    // ‼️ 옵셔널 바인딩으로 안전하게 처리
                    if let name = data.name, data.pieceId != nil {
                        self?.resultName = name
//                        self?.resultPieceId = pieceId
                    } else {
                        // 꽝인 경우 (ifNotLose가 false인 경우)
                        self?.resultName = nil // 또는 "꽝"으로 설정
                        // resultPieceId는 0으로 유지
                        // TODO: 꽝일 때의 UI 처리 (예: 알림창)
                    }
                    
                    self?.isAnimating = false
                    self?.showText = false
                case .failure(let error):
                    print("❌ 랜덤 뽑기 실패:", error)
                    self?.resultName = nil
//                    self?.resultPieceId = -1
                    self?.isAnimating = false
                    self?.showText = false
                }
            }
        }
    }
}
