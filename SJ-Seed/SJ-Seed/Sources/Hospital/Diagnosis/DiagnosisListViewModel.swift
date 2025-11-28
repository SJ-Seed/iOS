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
//    private let memberId = 1 // 임시 하드코딩
    private var memberId: Int {
        return AuthManager.shared.currentMemberId
    }
    
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
        let asset = PlantAssets.find(bySpeciesId: item.speciesId)
        let iconName = asset?.iconName ?? "sprout"
        
        let profile = PlantProfile(
            id: UUID(),
            name: item.plantName,
            iconName: iconName
        )
        
        return MedicalRecord(
            plantProfile: profile,
            dateText: dateText,
            diagnosis: diagnosis,
            plantId: item.plantId,
            speciesId: item.speciesId,
            treatmentId: item.treatmentId
        )
    }
}
