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
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - 반복되는 구름 배경 (고정)
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
            
            VStack(spacing: 0) {
                // 헤더는 스크롤되지 않고 상단 고정
                headerView
                
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
                    // MARK: - 기록이 있을 때 (수정된 부분)
                    // ScrollView 영역의 크기를 구하기 위해 GeometryReader 사용
                    GeometryReader { scrollProxy in
                        ScrollView {
                            // Spacer()가 작동하려면 LazyVStack이 아닌 VStack이어야 함
                            VStack(spacing: 0) {
                                
                                // 리스트 아이템들
                                ForEach(viewModel.records.reversed()) { record in
                                    ListComponent(item: record, onInfoTap: { di.router.push(.treatmentDetail(treatmentId: record.treatmentId)) })
                                        .padding(.bottom, 8)
                                }
                                
                                // [핵심] 내용이 짧으면 잔디를 바닥으로 밀어버리는 역할
                                Spacer(minLength: 0)
                                
                                // 맨 밑 잔디 배경 (ScrollView 안에 포함됨)
                                ZStack(alignment: .bottom) {
                                    Image(.grassBG)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.top, 40)
                                    
                                    CharacterSpeechComponent(characterImage: .doctor1, textString: "지금까지의\n진료기록이란다.")
                                        .offset(y: -30)
                                }
                            }
                            // [핵심] VStack의 최소 높이를 화면(ScrollView) 높이만큼 강제 설정
                            .frame(minHeight: scrollProxy.size.height)
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom) // 잔디가 바닥까지 꽉 차게
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
            
            Text("진료 기록")
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
                .foregroundStyle(.brown1)
        }
    }
}

#Preview {
    DiagnosisListView()
}
