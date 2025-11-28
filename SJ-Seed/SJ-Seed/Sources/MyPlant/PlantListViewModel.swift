//
//  PlantListViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/11/25.
//

import Foundation
import Combine

final class PlantListViewModel: ObservableObject {
    @Published var plantList: [PlantInfo] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let service = MyPlantService.shared
    
    func fetchPlantList() {
        let memberId = AuthManager.shared.currentMemberId
        
        guard memberId != 0 else {
            print("❌ PlantListViewModel: 로그인된 멤버 ID가 없습니다.")
            self.errorMessage = "로그인이 필요합니다."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        service.getPlantList(memberId: memberId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let items):
                    self?.plantList = items.map { item in
                        
                        // 1. ‼️ species가 있으면 찾고, 없으면(nil) 기본 아이콘 사용
                        let iconName: String
                        if let speciesName = item.species,
                           let asset = PlantAssets.find(by: speciesName) {
                            iconName = asset.iconName
                        } else {
                            iconName = "questionmark" // ❓ 알 수 없음 아이콘
                        }
                        
                        // 2. PlantProfile 생성
                        let profile = PlantProfile(
                            id: UUID(),
                            name: item.name,
                            iconName: iconName
                        )
                        
                        let dateText = (item.broughtDate.replacingOccurrences(of: "-", with: ".") + " ~")
                        let diagnosis: DiagnosisType = item.diseased ? .disease("질병이 의심돼요") : .normal
                        
                        // 3. ‼️ speciesId가 nil이면 0 등으로 처리
                        return PlantInfo(
                            plantProfile: profile,
                            dateText: dateText,
                            diagnosis: diagnosis,
                            speciesId: item.speciesId ?? 0, // 0 = 알 수 없음
                            plantId: item.id
                        )
                    }
                case .failure(let error):
                    print("❌ 식물 리스트 조회 실패:", error)
                    self?.errorMessage = "식물 목록을 불러오지 못했어요 😢"
                }
            }
        }
    }
}
