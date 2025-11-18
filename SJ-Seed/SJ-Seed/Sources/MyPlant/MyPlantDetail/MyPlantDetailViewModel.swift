//
//  MyPlantDetailViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/18/25.
//

import Foundation
import Combine

@MainActor // UI 업데이트를 메인 스레드에서 하도록 보장
final class MyPlantDetailViewModel: ObservableObject {
    
    @Published var detail: PlantDetailResult? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // 이전 턴에서 만든 'PlantService'를 사용합니다.
    private let service = PlantService.shared
    
    /**
     * 'plantId' (사용자의 식물 ID)를 사용해
     * 상세 정보를 가져옵니다.
     */
    func fetchDetail(plantId: Int) {
        isLoading = true
        errorMessage = nil
        
        service.getPlantDetail(plantId: plantId) { [weak self] result in
            // @MainActor를 사용하므로 DispatchQueue.main.async가 필요 없습니다.
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let data):
                // 'data'는 'PlantDetailResult' 타입입니다.
                self.detail = data
                
            case .failure(let error):
                print("❌ 내 식물 상세 정보 로드 실패:", error)
                self.errorMessage = "정보를 불러오지 못했어요 😢"
            }
        }
    }
}
