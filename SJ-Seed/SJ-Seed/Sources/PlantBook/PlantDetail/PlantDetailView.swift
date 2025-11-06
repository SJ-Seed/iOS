//
//  PlantDetailView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/30/25.
//

import SwiftUI

struct PlantDetailView: View {
    @Environment(\.diContainer) private var di
    
//    let plant: PlantBookModel
    let plant = PlantBookModel(
        id: UUID(),
        plant: PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"),
        rarity: 2
    )
//    let detail: PlantDetailModel
    let pieceId: Int = 6 // 현재는 하드코딩
    
    @StateObject private var viewModel = PlantDetailViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
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
            
            // MARK: - 로딩 중 표시
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
                    .font(Font.OwnglyphMeetme.regular.font(size: 24))
                    .foregroundColor(.brown1)
            }
            // MARK: - 에러 표시
            else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.headline)
            }
            
            else if let detail = viewModel.detail {
                ScrollView {
                    VStack {
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
                        
                        // MARK: - 상단 식물 정보
                        PlantInfoHeader(plant: plant)
                        
                        // MARK: - 섹션별 정보
                        VStack {
                            PlantInfoSection(title: "설명", content: detail.description)
                            PlantInfoSection(title: "식물이 자라는 과정", content: detail.growthProcess)
                            PlantInfoSection(title: "식물이 자라는 좋은 환경", content: detail.goodEnvironment)
                            PlantInfoSection(title: "물은 언제 주나요?", content: detail.watering)
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
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .task {
            viewModel.fetchPlantDetail(pieceId: pieceId)
        }
    }
}

struct PlantInfoHeader: View {
    let plant: PlantBookModel
    
    var body: some View {
        VStack(spacing: 0) {
            CloudPlantComponent(icon: Image("tomato"))
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
    // 예시용 프리뷰 데이터
//    let plant = PlantBookModel(
//        id: UUID(),
//        plant: PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"),
//        rarity: 2
//    )
    
//    let detail = PlantDetailModel(
//        description: "토마토는 빨갛고 동그란 열매로, 새콤달콤한 맛 때문에 샐러드나 주스로 자주 사용돼요. 비타민이 풍부해서 건강에 좋아요!",
//        growthProcess: "씨앗 → 새싹 → 줄기와 잎 → 꽃 → 열매(토마토)",
//        goodEnvironment: "온도: 20~25℃\n습도: 50~70%",
//        watering: "2~3일에 한 번,\n200~300ml 정도 줍니다."
//    )
    
    PlantDetailView()
}
