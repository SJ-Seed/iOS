//
//  TreatmentDetailView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/28/25.
//


import SwiftUI

struct TreatmentDetailView: View {
    @Environment(\.diContainer) private var di
    let treatmentId: Int // ‼️ ID 받음
    
    @StateObject private var viewModel = TreatmentDetailViewModel()
    
    var body: some View {
        ZStack(alignment: .top) { // 로딩 뷰 위치를 위해 top 정렬
            // 배경 (공통)
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
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("불러오는 중...")
                        .font(Font.OwnglyphMeetme.regular.font(size: 24))
                        .foregroundStyle(.brown1)
                    Spacer()
                }
                else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error)
                        .font(Font.OwnglyphMeetme.regular.font(size: 24))
                        .foregroundStyle(.red)
                    Spacer()
                }
                else if let detail = viewModel.resultDetail, let plant = viewModel.plantProfile {
                    // MARK: - 데이터 로드 완료
                    ScrollView {
                        VStack {
                            Spacer().padding(.top, 20)
                            
                            // 상태 메시지는 API에 없으므로 진단명 사용하거나 기본값
                            BrownSpeechBubbleComponent(textString: "병에 걸렸어요...")
                            
                            CloudPlantComponent(bg: Image(.cloudCircle), icon: plant.icon, size: 170)
                            
                            Text(plant.name)
                                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                                .foregroundStyle(Color.brown1)
                            
                            DiseaseDetailCard(
                                diseaseName: detail.disease ?? "진단명 없음",
                                symptom: detail.explain ?? "증상 정보가 없습니다.",
                                cause: detail.cause.map { $0 + "\n최근 일주일 동안의 높은 습도 때문에 이 병이 생겼을 가능성이 있어요" } ?? "원인 정보가 없습니다.",
                                treatment: detail.cure ?? "치료법 정보가 없습니다."
                            )
//                            .padding(.horizontal)
                            
                            EnvironmentGraphView()
                                .padding(.horizontal, 25)
                                .padding(.top, 10)
                            
                            ZStack {
                                Image(.grassBG)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.top, 40)
                                VStack {
                                    CharacterSpeechComponent(
                                        characterImage: .doctor1,
                                        textString: "아이쿠!\n치료가 필요하겠는걸?"
                                    )
//                                    .padding(.bottom, 20)
                                }
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .task {
            viewModel.fetchDetail(treatmentId: treatmentId)
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
            Text("진료 기록 상세")
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
                .foregroundStyle(.brown1)
        }
    }
}

#Preview {
    TreatmentDetailView(treatmentId: 1)
}
