//
//  DiagnosisListViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/26/25.
//


import Foundation
import Combine

@MainActor
final class DiagnosisListViewModel: ObservableObject {
    
    @Published var records: [MedicalRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let service = HospitalService.shared
    private let memberId = 1 // 임시 하드코딩
    
    func fetchRecords() {
        isLoading = true
        errorMessage = nil
        
        service.getTreatmentList(memberId: memberId) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let items):
                // [TreatmentListItem] -> [MedicalRecord] 변환
                self.records = items.map { item in
                    self.createMedicalRecord(from: item)
                }
//                self.records = mappedRecords.sorted { $0.dateText > $1.dateText }
                
            case .failure(let error):
                print("❌ 진료 기록 로드 실패:", error)
                self.errorMessage = "진료 기록을 불러오지 못했어요 😢"
            }
        }
    }
    
    private func createMedicalRecord(from item: TreatmentListItem) -> MedicalRecord {
        // 1. 날짜 포맷 변환 (YYYY-MM-DD -> YYYY.MM.DD)
        let dateText = item.date.replacingOccurrences(of: "-", with: ".")
        
        // 2. 진단 상태 변환
        let diagnosis: DiagnosisType
        if let diseaseName = item.disease {
            diagnosis = .disease(diseaseName)
        } else {
            diagnosis = .normal
        }
        
        // 3. 식물 프로필 생성
        // 주의: API에 species(종류)가 없으므로 아이콘을 정확히 찾기 어려움.
        // 이름으로 PlantAssets를 검색해보고, 없으면 기본 아이콘 사용
        let asset = PlantAssets.find(by: item.plantName)
        let iconName = asset?.iconName ?? "sprout"
        
        let profile = PlantProfile(
            id: UUID(),
            name: item.plantName,
            iconName: iconName
        )
        
        return MedicalRecord(
            plantProfile: profile,
            dateText: dateText,
            diagnosis: diagnosis
        )
    }
}
