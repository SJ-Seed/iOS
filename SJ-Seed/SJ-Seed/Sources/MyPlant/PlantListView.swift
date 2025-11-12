//
//  PlantListView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantListView: View {
//    let plantList: [PlantInfo]
    @Environment(\.diContainer) private var di
    @StateObject private var viewModel = PlantListViewModel()
    
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
            
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
                    .font(Font.OwnglyphMeetme.regular.font(size: 24))
                    .foregroundStyle(Color.green1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 20) {
                    Text(error)
                        .font(Font.OwnglyphMeetme.regular.font(size: 24))
                        .foregroundColor(.red)
                    Button("다시 시도") {
                        viewModel.fetchPlantList(memberId: 1) // 예시 memberId
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                // MARK: - ScrollView 콘텐츠
                VStack {
                    headerView
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.plantList) { record in
                                ListComponent(item: record) {
                                    di.router.push(.plantDetail(speciesId: record.speciesId))
                                }
                                    .padding(.bottom, 8)
                            }
                            Button(action: { di.router.push(.plantRegister) }) {
                                Text("식물을 추가하려면 누르세요")
                                    .font(Font.OwnglyphMeetme.regular.font(size: 30))
                                    .foregroundStyle(Color.green1)
                                    .frame(width: 350, height: 80)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.ivory1)
                                            .opacity(0.3)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.green1, lineWidth: 4)
                                            )
                                    )
                            }
                            Spacer()
                            
                            // 맨 밑 잔디 배경
                            ZStack {
                                Image(.grassBG)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.top, 40)
                                CharacterSpeechComponent(characterImage: .grandma2, textString: "식물을 확인하거나\n등록할 수 있단다.")
                            }
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .task {
            viewModel.fetchPlantList(memberId: 1) // 예시 memberId (로그인 ID로 교체 필요)
        }
    }
    
    private var headerView: some View {
        ZStack {
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
            
            // 인덱스 중앙
            Text("나의 식물")
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
                .foregroundStyle(.brown1)
        }
//        .background(Color.clear)
    }
}

#Preview {
//    let sampleProfiles = [
//        PlantProfile(id: UUID(), name: "똥맛토", iconName: "tomato"),
//        PlantProfile(id: UUID(), name: "토맛똥", iconName: "tomato"),
//        PlantProfile(id: UUID(), name: "고추", iconName: "basil")
//    ]
//    
//    let sampleRecords = [
//        PlantInfo(plantProfile: sampleProfiles[0], dateText: "2025.09.01 ~", diagnosis: .normal),
//        PlantInfo(plantProfile: sampleProfiles[1], dateText: "2025.09.07 ~", diagnosis: .disease("점무늬병")),
//        PlantInfo(plantProfile: sampleProfiles[2], dateText: "2025.09.10 ~", diagnosis: .normal)
//    ]
//    PlantListView(plantList: sampleRecords)
    PlantListView()
}
