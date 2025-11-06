//
//  PlantDetailViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/6/25.
//

import Foundation

final class PlantDetailViewModel: ObservableObject {
    @Published var detail: PieceDetail? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let service = CollectionService.shared
    
    func fetchPlantDetail(speciesId: Int) {
        isLoading = true
        errorMessage = nil
        
        service.getPieceDetail(speciesId: speciesId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    print("🌱 상세 정보 불러오기 성공:", data.name)
                    self?.detail = data
//                    self?.detail = PlantDetailModel(
//                        description: data.description,
//                        growthProcess: data.process,
//                        goodEnvironment: "온도: \(data.properTemp)\n습도: \(data.properHum)",
//                        watering: data.water
//                    )
                case .failure(let error):
                    print("❌ 상세 정보 불러오기 실패:", error)
                    self?.errorMessage = "불러오기에 실패했어요 😢"
                }
            }
        }
    }
}
