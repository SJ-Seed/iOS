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
    
    func fetchPlantList(memberId: Int) {
        isLoading = true
        errorMessage = nil
        
        service.getPlantList(memberId: memberId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let items): // 'items'는 [PlantListItem] 타입
                    
                    // [PlantListItem]을 [PlantInfo]로 변환 (매핑)
                    self?.plantList = items.map { item in
                        
                        // 'species' ("토마토", "바질" 등)로 'iconName' ("tomato", "basil")을 찾습니다.
                        // (이전에 작업한 PlantAssets 헬퍼 함수를 사용)
                        let asset = PlantAssets.find(by: item.species)
                        let iconName = asset?.iconName ?? "sprout" // 기본 아이콘
                        
                        let profile = PlantProfile(
                            id: UUID(), // View에서만 사용할 임시 ID
                            name: item.name, // 사용자가 지은 식물 이름
                            iconName: iconName
                        )
                        
                        // API 날짜 형식을 View 형식으로 변환 (예: "YYYY-MM-DD" -> "YYYY.MM.DD ~")
                        let dateText = (item.broughtDate.replacingOccurrences(of: "-", with: ".") + " ~")
                        
                        // 'diseased' (Bool)를 'DiagnosisType'으로 변환
                        let diagnosis: DiagnosisType = item.diseased ? .disease("질병이 의심돼요") : .normal
                        
                        return PlantInfo(
                            plantProfile: profile,
                            dateText: dateText,
                            diagnosis: diagnosis,
                            speciesId: item.speciesId
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
