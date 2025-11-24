//
//  HospitalViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/24/25.
//

import Foundation
import Combine

@MainActor
final class HospitalViewModel: ObservableObject {
    
    // UI에 바인딩될 식물 리스트
    @Published var userPlants: [PlantProfile] = []
    
    // 현재 선택된 식물 (Picker와 바인딩)
    @Published var selectedPlant: PlantProfile
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let service = MyPlantService.shared
    private let memberId = 1 // 임시 하드코딩 (로그인 연동 시 변경 필요)
    
    init() {
        // 초기값: 로딩 전 보여줄 더미 데이터 혹은 빈 값
        // (PlantProfile은 id가 UUID이므로 임시 객체 생성)
        self.selectedPlant = PlantProfile(id: UUID(), name: "식물을 불러오는 중...", iconName: "sprout")
    }
    
    func fetchUserPlants() {
        isLoading = true
        errorMessage = nil
        
        service.getPlantList(memberId: memberId) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let items):
                // 1. [PlantListItem] -> [PlantProfile] 변환
                let profiles: [PlantProfile] = items.map { item in
                    
                    // 식물 종류(item.species)를 이용해 아이콘 찾기
                    let asset = PlantAssets.find(by: item.species)
                    let iconName = asset?.iconName ?? "sprout"
                    
                    return PlantProfile(
                        id: UUID(), // UI 식별용 고유 ID 생성
                        name: item.name, // 사용자가 지은 닉네임
                        iconName: iconName
                    )
                }
                
                self.userPlants = profiles
                
                // 2. 리스트가 있다면 첫 번째 식물을 기본 선택
                if let firstPlant = profiles.first {
                    self.selectedPlant = firstPlant
                } else {
                    // 식물이 없을 경우 처리
                    self.selectedPlant = PlantProfile(id: UUID(), name: "등록된 식물 없음", iconName: "questionmark")
                }
                
            case .failure(let error):
                print("❌ 병원 뷰 식물 로드 실패:", error)
                self.errorMessage = "식물 목록을 불러오지 못했어요."
            }
        }
    }
}
