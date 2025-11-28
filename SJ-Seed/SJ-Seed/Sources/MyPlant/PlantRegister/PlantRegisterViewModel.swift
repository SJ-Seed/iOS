//
//  PlantRegisterViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/12/25.
//

import Foundation

@MainActor // UI 업데이트를 메인 스레드에서 하도록 보장
final class PlantRegisterViewModel: ObservableObject {
    
    // API 통신 상태
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // API 성공 시 채워질 변수
    @Published var registeredPlantUserName: String = "" // 사용자가 지은 이름 (예: "똥맛토")
    @Published var registeredPlantSpeciesName: String = "" // 식물 종류 이름 (예: "토마토")
    
    private let service = MyPlantService.shared
//    private let memberId = 1 // 임시 하드코딩
    private var memberId: Int {
        return AuthManager.shared.currentMemberId
    }
    
    // API 호출 함수
    // 'completion' 핸들러로 뷰의 'step'을 변경할지 여부를 알림
    func registerPlant(name: String, code: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        service.registerPlant(memberId: memberId, name: name, code: code) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let data): // 'data'는 'RegisterPlantResult'
                print("✅ 식물 등록 성공: \(data.name)")
                
                // 1. API가 반환한 '사용자 지정 이름' 저장
                self.registeredPlantUserName = data.name
                
                // 2. API가 반환한 'speciesId'로 'PlantAssets'에서 '종류 이름' 찾기
//                if let asset = PlantAssets.find(bySpeciesId: data.speciesId) {
//                    self.registeredPlantSpeciesName = asset.name
//                } else {
//                    self.registeredPlantSpeciesName = "알 수 없는 식물" // 예외 처리
//                }
                
                completion(true) // 성공
                
            case .failure(let error):
                print("❌ 식물 등록 실패:", error)
                self.errorMessage = "등록에 실패했어요 😢\n코드가 올바른지 확인해주세요."
                completion(false) // 실패
            }
        }
    }
}
