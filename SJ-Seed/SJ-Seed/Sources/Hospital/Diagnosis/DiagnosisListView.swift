//
//  DiagnosisListView.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/30/25.
//

import SwiftUI

struct DiagnosisListView: View {
    @Environment(\.diContainer) private var di
    @StateObject private var viewModel = DiagnosisListViewModel()
//    let records: [MedicalRecord]
    
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
            
            VStack {
                headerView
                // MARK: - ScrollView 콘텐츠
                // MARK: - 로딩 및 에러 처리
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("기록을 불러오는 중...")
                            .font(Font.OwnglyphMeetme.regular.font(size: 24))
                            .foregroundStyle(.brown1)
                        Spacer()
                    }
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        Text(error)
                            .font(Font.OwnglyphMeetme.regular.font(size: 24))
                            .foregroundStyle(.red)
                        Spacer()
                    }
                } else if viewModel.records.isEmpty {
                    // 기록이 없을 때
                    VStack {
                        Spacer()
                        Text("아직 진료 기록이 없어요 🌱")
                            .font(Font.OwnglyphMeetme.regular.font(size: 24))
                            .foregroundStyle(.brown1)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack {
        //                    Spacer().padding(.top, 80)
                            ForEach(viewModel.records.reversed()) { record in
                                ListComponent(item: record, onInfoTap: { di.router.push(.myPlantDetail(plantId: record.plantId)) })
                                    .padding(.bottom, 8)
                            }
                            Spacer()
                            
                            // 맨 밑 잔디 배경
                            ZStack {
                                Image(.grassBG)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.top, 40)
                                CharacterSpeechComponent(characterImage: .doctor1, textString: "지금까지의\n진료기록이란다.")
                            }
                        }
        //                .padding(.vertical, 20)
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .task {
            viewModel.fetchRecords()
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
            Text("진료 기록")
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
                .foregroundStyle(.brown1)
        }
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
//        MedicalRecord(plantProfile: sampleProfiles[0], dateText: "2025.09.03", diagnosis: .normal),
//        MedicalRecord(plantProfile: sampleProfiles[1], dateText: "2025.09.07", diagnosis: .disease("점무늬병")),
//        MedicalRecord(plantProfile: sampleProfiles[2], dateText: "2025.09.10", diagnosis: .normal)
//    ]
    DiagnosisListView()
}
