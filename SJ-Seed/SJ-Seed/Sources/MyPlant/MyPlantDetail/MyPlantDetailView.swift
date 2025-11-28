//
//  MyPlantDetailView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/18/25.
//

import SwiftUI

struct MyPlantDetailView: View {
    @Environment(\.diContainer) private var di
    let plantId: Int // 'speciesId'가 아닌 'plantId'를 받습니다.
    
    @StateObject private var viewModel = MyPlantDetailViewModel()
    
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
            
            // ‼️ 'PlantDetailView'와 동일한 'VStack + ScrollView' 구조
            VStack {
                // --- 상단 뒤로가기 버튼 ---
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
                
                ScrollView {
                    LazyVStack {
                        // --- API 로드 컨텐츠 ---
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
                            // 'detail' (PlantDetailResult)을 성공적으로 로드
                            
                            // 1. 'detail.species' ("토마토")로 'PlantAssets'에서 정적 정보(아이콘, 희귀도) 찾기
                            let staticAsset = PlantAssets.find(by: detail.species)
                            if staticAsset == nil {
                                let _ = print("⚠️ 경고: '\(detail.species)'에 해당하는 식물을 PlantAssets에서 찾을 수 없습니다.")
                            }
                            
                            // 2. 'PlantBookModel'을 동적으로 생성
                            let headerModel = PlantBookModel(
                                id: UUID(),
                                plant: PlantProfile(
                                    id: UUID(),
                                    name: detail.name, // 👈 API 응답 (사용자 지정 이름)
                                    iconName: staticAsset?.iconName ?? "sprout" // 👈 PlantAssets
                                ),
                                rarity: staticAsset?.rarity ?? 0, // 👈 PlantAssets
                                speciesId: 0 // (이 뷰에서는 사용되지 않음)
                            )
                            
                            // MARK: - 상단 식물 정보
                            PlantInfoDetailVerHeader(plant: headerModel, brougtDate: "♥ 등록 날짜: \(detail.broughtDate.replacingOccurrences(of: "-", with: ".")) ♥")
                            
                            // MARK: - 섹션별 정보 (PlantDetailResult 모델 기준)
                            VStack {
                                // 'PlantDetailResult'에는 'process'가 없으므로
                                // 'description'으로 대체하거나 API 응답 스펙 확인 필요
                                PlantInfoSection(title: "식물 종류", content: detail.species)
                                PlantInfoSection(title: "설명", content: detail.description)
                                PlantInfoSection(title: "식물이 자라기 좋은 환경", content: "온도: \(detail.properTemp)℃\n습도: \(detail.properHum)%")
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
        }
        .task {
            // 'plantId'로 ViewModel의 함수 호출
            viewModel.fetchDetail(plantId: plantId)
        }
    }
}

// MARK: - (PlantDetailView.swift와 동일한 헬퍼 뷰들)

struct PlantInfoDetailVerHeader: View {
    let plant: PlantBookModel
    let brougtDate: String
    
    var body: some View {
        VStack(spacing: 0) {
            CloudPlantComponent(icon: Image(plant.plant.iconName))
                .padding(.bottom, 8)
            
            Text(plant.plant.name)
                .foregroundStyle(.brown1)
                .font(Font.OwnglyphMeetme.regular.font(size: 36))
            
            Text(brougtDate)
                .foregroundStyle(.brown1)
                .font(Font.OwnglyphMeetme.regular.font(size: 22))
        }
    }
}

#Preview {
    MyPlantDetailView(plantId: 2) // 테스트용 ID
}
