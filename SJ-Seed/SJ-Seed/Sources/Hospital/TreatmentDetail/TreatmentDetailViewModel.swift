import Foundation
import Combine

@MainActor
final class TreatmentDetailViewModel: ObservableObject {
    
    @Published var resultDetail: TreatmentDetailResult? = nil
    @Published var plantProfile: PlantProfile? = nil
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let hospitalService = HospitalService.shared
    private let plantService = PlantService.shared
    
    func fetchDetail(treatmentId: Int) {
        isLoading = true
        errorMessage = nil
        
        // 1. 진료 기록 상세 조회
        hospitalService.getTreatmentDetail(treatmentId: treatmentId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let treatmentData):
                self.resultDetail = treatmentData
                
                // 2. 획득한 'plantId'로 식물 상세 정보(닉네임) 조회
                self.fetchPlantNickname(plantId: treatmentData.plantId, speciesId: treatmentData.speciesId)
                
            case .failure(let error):
                print("❌ 진료 상세 로드 실패:", error)
                self.isLoading = false
                self.errorMessage = "상세 정보를 불러오지 못했어요 😢"
            }
        }
    }
    
    // 식물 닉네임 가져오기
    private func fetchPlantNickname(plantId: Int, speciesId: Int) {
        plantService.getPlantDetail(plantId: plantId) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false // 모든 로딩 끝
            
            // 아이콘은 speciesId로 로컬에서 찾음 (공통)
            let asset = PlantAssets.find(bySpeciesId: speciesId)
            let iconName = asset?.iconName ?? "sprout"
            
            switch result {
            case .success(let plantData):
                // ✅ 성공: API에서 받은 닉네임 사용
                print("✅ 식물 닉네임 로드 성공: \(plantData.name)")
                
                self.plantProfile = PlantProfile(
                    id: UUID(),
                    name: plantData.name, // 진짜 닉네임 ("똥맛토")
                    iconName: iconName
                )
                
            case .failure(let error):
                print("⚠️ 식물 상세 로드 실패 (기본 이름 사용):", error)
                
                // 실패 시: 로컬 에셋 이름("토마토")을 대신 사용
                let fallbackName = asset?.name ?? "알 수 없는 식물"
                
                self.plantProfile = PlantProfile(
                    id: UUID(),
                    name: fallbackName,
                    iconName: iconName
                )
            }
        }
    }
}
