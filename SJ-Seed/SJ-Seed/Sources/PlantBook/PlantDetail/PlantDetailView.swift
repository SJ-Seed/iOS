//
//  PlantDetailView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/30/25.
//

import SwiftUI

struct PlantDetailView: View {
    @Environment(\.diContainer) private var di
    let speciesId: Int
    
    @StateObject private var viewModel = PlantDetailViewModel()
    
    private var staticAsset: PlantAsset? {
        return PlantAssets.find(bySpeciesId: speciesId)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - 반복되는 구름 배경
            GeometryReader { geometry in
                LazyVStack(spacing: 0) {
                    ForEach(0..<2) { _ in
                        Image(.cloudBG)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width)
                    }
                }
            }
            .ignoresSafeArea()
            
            if let _ = staticAsset {
                ScrollView {
                    LazyVStack {
                        HStack {
                            Button(action: { di.router.pop() }) {
                                Image("chevronLeft")
                                    .foregroundStyle(.brown1)
                                    .padding(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            Spacer()
                        }
                        if viewModel.isLoading {
                            ProgressView("불러오는 중...")
                                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                                .foregroundColor(.brown1)
                                .padding(.top, 300)
                        }
                        else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.headline)
                                .padding(.top, 100)
                            Button("돌아가기") { di.router.pop() }
                        }
                        else if let detail = viewModel.detail {
                            let headerModel = PlantBookModel(
                                id: UUID(),
                                plant: PlantProfile(
                                    id: UUID(),
                                    name: detail.name,
                                    iconName: staticAsset?.iconName ?? "sprout"
                                ),
                                rarity: detail.rarity,
                                speciesId: speciesId
                            )
                            // MARK: - 상단 식물 정보
                            PlantInfoHeader(plant: headerModel)
                            
                            // MARK: - 섹션별 정보
                            VStack {
                                PlantInfoSection(title: "설명", content: detail.description)
                                PlantInfoSection(title: "식물이 자라는 과정", content: detail.process)
                                PlantInfoSection(title: "식물이 자라는 좋은 환경", content: "온도: \(detail.properTemp), 습도: \(detail.properHum)")
                                PlantInfoSection(title: "물은 언제 주나요?", content: detail.water)
                            }
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.ivory1)
                                    .padding(.horizontal, 30)
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                            )
                            
                            ZStack {
                                Image(.grassBG)
                                    .resizable()
                                    .scaledToFit()
                                CharacterSpeechComponent(
                                    characterImage: .student,
                                    textString: "열심히 키워서\n예쁜 열매를 맺어봐요!"
                                )
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
            else {
                VStack {
                    Text("잘못된 식물 ID입니다: \(speciesId)")
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                    Button("돌아가기") { di.router.pop() }
                }
                
            }
        }
        .task {
            viewModel.fetchPlantDetail(speciesId: speciesId)
        }
        
    }
}

struct PlantInfoHeader: View {
    let plant: PlantBookModel
    
    var body: some View {
        VStack(spacing: 0) {
            CloudPlantComponent(icon: Image(plant.plant.iconName))
                .padding(.bottom, 8)
            
            Text(plant.plant.name)
                .foregroundStyle(.brown1)
                .font(Font.OwnglyphMeetme.regular.font(size: 36))
            
            HStack(spacing: 4) {
                ForEach(0..<plant.rarity, id: \.self) { _ in
                    Image(.star)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
}

struct PlantInfoSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .multilineTextAlignment(.center)
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
                .foregroundStyle(.green1)
            
            Text(content)
                .multilineTextAlignment(.center)
                .font(Font.OwnglyphMeetme.regular.font(size: 22))
                .foregroundStyle(.brown1)
                .lineSpacing(4)
        }
        .padding()
        .padding(.horizontal, 60)
        
    }
}

#Preview {
    PlantDetailView(speciesId: 6)
}
