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
                    print("🌱 뽑힌 식물: \(data.name)")
                    self?.resultName = data.name
                    self?.isAnimating = false
                    self?.showText = false
                case .failure(let error):
                    print("❌ 랜덤 뽑기 실패:", error)
                    self?.resultName = "실패했어요 😢"
                    self?.isAnimating = false
                    self?.showText = false
                }
            }
        }
    }
}
