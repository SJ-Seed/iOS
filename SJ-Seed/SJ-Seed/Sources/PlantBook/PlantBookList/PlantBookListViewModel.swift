//
//  PlantBookListViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/4/25.
//

import Foundation
import Combine

final class PlantBookListViewModel: ObservableObject {
    @Published var plantList: [PlantBookModel] = []
    private let service = CollectionService.shared
//    private var cancellables = Set<AnyCancellable>()
//    private let allPlants = [
//        "상추", "바질", "감자", "강낭콩", "토마토",
//        "딸기", "고추", "블루베리", "체리", "라즈베리",
//        "포도", "복숭아"
//    ]
    
    func fetchPlantList(memberId: Int) {
        service.getPieceList(memberId: memberId) { [weak self] (result: Result<[PieceListItem], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                // ‼️ 1. .enumerated()를 사용해 (index, asset)을 가져옴
                let fullList: [PlantBookModel] = PlantAssets.all.enumerated().map { (index, asset) in
                    
                    // ‼️ 2. 서버 ID는 index + 1
                    let speciesId = index + 1
                    
                    if let item = items.first(where: { $0.name == asset.name }) {
                        // 서버에 존재하는 식물 (보유)
                        return PlantBookModel(
                            id: UUID(),
                            plant: PlantProfile(id: UUID(), name: asset.name, iconName: asset.iconName),
                            rarity: item.rarity,
                            pieceId: nil, // ‼️ 3. 'pieceId'가 PieceListItem에 있다면 저장
                            speciesId: speciesId   // ‼️ 4. 'speciesId' 저장
                        )
                    } else {
                        // 서버에 없는 식물 (미보유)
                        return PlantBookModel(
                            id: UUID(),
                            plant: PlantProfile(id: UUID(), name: "???", iconName: "questionmark"),
                            rarity: 0,
                            pieceId: nil,
                            speciesId: speciesId   // ‼️ 4. 'speciesId' 저장
                        )
                    }
                }
                
                DispatchQueue.main.async {
                    self.plantList = fullList
                }
                
            case .failure(let error):
                print("❌ 도감 리스트 불러오기 실패: \(error)")
            }
        }
    }
}
