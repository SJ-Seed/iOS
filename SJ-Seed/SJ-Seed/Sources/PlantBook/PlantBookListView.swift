//
//  PlantBookListView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/29/25.
//

import SwiftUI

struct PlantBookListView: View {
    let plantList: [PlantBookModel] = [
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"), rarity: 2),
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "상추", iconName: "lettuce"), rarity: 1),
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "바질", iconName: "basil"), rarity: 1),
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "딸기", iconName: "strawberry"), rarity: 2),
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "바질", iconName: "basil"), rarity: 1),
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "딸기", iconName: "strawberry"), rarity: 2),
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"), rarity: 2),
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "상추", iconName: "lettuce"), rarity: 1),
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "딸기", iconName: "strawberry"), rarity: 2),
        PlantBookModel(id: UUID(), plant: PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"), rarity: 2)
    ]
    @StateObject private var viewModel = PlantBookListViewModel()
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - 반복되는 구름 배경
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ForEach(0..<2) { _ in
                        Image(.cloudBG)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width)
                    }
                }
            }
            .ignoresSafeArea()
            
            // MARK: - ScrollView 콘텐츠
            ScrollView {
                VStack {
                    Spacer().padding(.top, 80)
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.plantList) { plant in
                            PlantBookComponent(plant: plant)
                        }
                    }
                    .padding(.vertical, 25)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.ivory1)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    )
                    .padding(.horizontal, 35)
                    
                    Spacer()
                    
                    // 맨 밑 잔디 배경
                    ZStack {
                        Image(.grassBG)
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 40)
                        CharacterSpeechComponent(characterImage: .student, textString: "지금까지 모은\n도감 목록이야.")
                    }
                }
            }
            .ignoresSafeArea()
        }
        .task {
            viewModel.fetchPlantList(memberId: 1) // 예시로 memberId = 1
        }
    }
}

#Preview {
    PlantBookListView()
}
