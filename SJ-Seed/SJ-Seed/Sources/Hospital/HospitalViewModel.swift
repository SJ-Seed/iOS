//
//  HospitalViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/24/25.
//

import Foundation
import Combine
import UIKit
import PhotosUI
import SwiftUI

@MainActor
final class HospitalViewModel: ObservableObject {
    
    // UI에 바인딩될 식물 리스트
    @Published var userPlants: [PlantProfile] = []
    
    // 현재 선택된 식물 (Picker와 바인딩)
    @Published var selectedPlant: PlantProfile
    
    @Published var selectedItems: [PhotosPickerItem] = []
    @Published var selectedImage: UIImage? = nil
    
    @Published var diagnosisResult: TreatmentResult? = nil
//    @Published var showResultModal = false
    var onDiagnosisComplete: ((TreatmentResult) -> Void)?
    
    @Published var isLoading = false
    @Published var isDiagnosisLoading = false
    @Published var errorMessage: String? = nil
    
    private var originalPlantItems: [PlantListItem] = []
    
    private var plantIdMap: [UUID: Int] = [:]
    private let myPlantService = MyPlantService.shared
    private let imageService = ImageService.shared
    private let hospitalService = HospitalService.shared
//    private let memberId = 1 // 임시 하드코딩
    private var memberId: Int {
        return AuthManager.shared.currentMemberId
    }
    
    init() {
        self.selectedPlant = PlantProfile(id: UUID(), name: "식물을 불러오는 중...", iconName: "sprout")
    }
    
    func fetchUserPlants() {
        isLoading = true
        errorMessage = nil
        
        myPlantService.getPlantList(memberId: memberId) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let items):
                self.originalPlantItems = items
                // 1. [PlantListItem] -> [PlantProfile] 변환
                let profiles: [PlantProfile] = items.map { item in
                    
                    // 식물 종류(item.species)를 이용해 아이콘 찾기
                    let asset = PlantAssets.find(by: item.species)
                    let iconName = asset?.iconName ?? "sprout"
                    let newUUID = UUID()
                    self.plantIdMap[newUUID] = item.plantId
                    
                    return PlantProfile(
                        id: newUUID, // UI 식별용 고유 ID 생성
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
    
    func requestDiagnosis() {
        guard let image = selectedImage else { return }
        // 현재 선택된 식물의 실제 ID(Int) 찾기
        guard let targetPlantId = plantIdMap[selectedPlant.id] else {
            self.errorMessage = "선택된 식물의 정보를 찾을 수 없습니다."
            return
        }
        
        isDiagnosisLoading = true
        errorMessage = nil
        
        if let item = selectedItems.first {
            print("📸 선택된 사진 ID: \(item.itemIdentifier ?? "알 수 없음")")
        }
        
        // A. 이미지 업로드
        imageService.uploadImage(image: image) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let imageUrl):
                print("✅ 이미지 업로드 성공 URL: \(imageUrl)")
                // B. 진료 API 호출 (업로드된 URL 사용)
                self.performTreatment(plantId: targetPlantId, imageUrl: imageUrl)
                
            case .failure(let error):
                print("❌ 이미지 업로드 실패:", error)
                self.isDiagnosisLoading = false
                self.errorMessage = "사진 업로드에 실패했어요."
            }
        }
    }
    
    private func performTreatment(plantId: Int, imageUrl: String) {
        hospitalService.treatPlant(memberId: memberId, plantId: plantId, imageUrl: imageUrl) { [weak self] result in
            guard let self = self else { return }
            self.isDiagnosisLoading = false
            
            switch result {
            case .success(let data):
                print("✅ 진료 완료")
                self.diagnosisResult = data
                self.onDiagnosisComplete?(data)
                
                self.selectedImage = nil
                self.selectedItems = []
                
            case .failure(let error):
                print("❌ 진료 요청 실패:", error)
                self.errorMessage = "진료를 보는데 실패했어요."
            }
        }
    }
    
    func loadSelectedImage() {
        guard let item = selectedItems.first else { return }
        
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.selectedImage = uiImage
            }
        }
    }
}
