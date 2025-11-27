//
//  PlantBookListView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/29/25.
//

import SwiftUI

struct PlantBookListView: View {
    @Environment(\.diContainer) private var di
    
    @StateObject private var viewModel = PlantBookListViewModel()
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
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
            
            // MARK: - ScrollView 콘텐츠
            if viewModel.isLoading {
                // --- 1. 로딩 중 ---
                ProgressView("불러오는 중...")
                    .font(Font.OwnglyphMeetme.regular.font(size: 24))
                    .foregroundStyle(.brown1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 20) {
                    Text(error)
                        .font(Font.OwnglyphMeetme.regular.font(size: 24))
                        .foregroundColor(.red)
                    Button("다시 시도") {
                        viewModel.fetchPlantList()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                VStack {
                    headerView
                    ScrollView {
                        LazyVStack {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.plantList) { plant in
                                    Button(action: {
                                        di.router.push(.plantDetail(speciesId: plant.speciesId))
                                    }) {
                                        PlantBookComponent(plant: plant)
                                    }
                                    .disabled(plant.plant.name == "???")
                                    .buttonStyle(.plain)
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
                            
                            footerView
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .task {
            viewModel.fetchPlantList()
        }
    }
    
    // MARK: - 헤더 뷰 (분리)
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
                Button(action: { di.router.push(.plantLottery) }) {
                    Text("뽑기")
                        .font(Font.OwnglyphMeetme.regular.font(size: 20))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.brown1)
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        )
                }
                .padding(.trailing, 24)
            }
            
            // 인덱스 중앙
            Text("도감")
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
                .foregroundStyle(.brown1)
        }
    }
    
    // MARK: - 푸터 뷰 (분리)
    private var footerView: some View {
        ZStack {
            Image(.grassBG)
                .resizable()
                .scaledToFit()
                .padding(.top, 40)
            CharacterSpeechComponent(characterImage: .student, textString: "지금까지 모은\n도감 목록이야.")
        }
    }
}

#Preview {
    PlantBookListView()
}
