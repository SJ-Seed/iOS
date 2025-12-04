//
//  HomeView.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/15/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.diContainer) private var di
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            HeaderBarGroup(
                coin: viewModel.coin,
                onTapMy: { di.router.push(.myPage) }
            )
            // 1. 로딩 중인지 가장 먼저 확인
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .controlSize(.large)
                        .tint(.brown1)
                    Spacer()
                }
                .frame(height: 300) // Pager와 같은 높이 확보
                
            }
            // 2. 로딩이 끝났는데 비어있는지 확인
            else if viewModel.plantStateViewModels.isEmpty {
                // 식물이 없을 때 (또는 로딩 전) 표시할 뷰
                VStack {
                    Spacer()
                    Text("등록된 식물이 없어요 🌱")
                        .font(Font.OwnglyphMeetme.regular.font(size: 24))
                        .foregroundStyle(.brown1)
                    Spacer()
                }
                .frame(height: 380) // Pager 높이만큼 확보
                
            } else {
                // API로 받아온 ViewModel 목록 전달
                PlantStatePager(
                    viewModels: viewModel.plantStateViewModels,
                    onInfoTap: { plantId in
                        di.router.push(.myPlantDetail(plantId: plantId))
                    },
                    // 물주기 성공 이벤트 처리 (Pager에도 이 클로저 파라미터 추가 필요)
                    onWaterTap: { plantId in
                        di.router.push(.letsWater(plantId: plantId))
                    }
                )
                .padding(.bottom)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(height: 100) // AttendanceComponent 높이만큼
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .frame(height: 100)
            } else {
                AttendanceComponent(
                    attendance: viewModel.attendance
                )
                .padding(.horizontal, 25)
            }
            HStack {
                MainButtonComponent(buttonImage: Image(.student), buttonText: "도감", moveTo: {di.router.push(.plantBookList)})
                MainButtonComponent(buttonImage: Image(.grandma2), buttonText: "식물", moveTo: {di.router.push(.myPlant)})
                MainButtonComponent(buttonImage: Image(.doctor1), buttonText: "병원", moveTo: {di.router.push(.hospital)})
            }
            .padding(.top, 15)
        }
        .background(
            Image(.background)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
        )
        .onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
        ) { _ in
            viewModel.refreshData()
        }
        .task {
            viewModel.refreshData()
        }
    }
}

struct HeaderBarGroup: View {
    var coin: Int
    var onTapMy: () -> Void = {}

    var body: some View {
        HStack {
            HeaderButton(
                icon: Image(.mypage),
                text: "MY",
                onTap: onTapMy
            )
            Spacer()
            HeaderButton(
                icon: Image(.coin),
                text: "\(coin)"
            )
        }
        .padding(.horizontal)
    }
}

struct HeaderButton: View {
    let icon: Image
    let text: String
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                Text(text)
                    .font(Font.OwnglyphMeetme.regular.font(size: 28))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundStyle(Color.ivory1)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    HomeView()
}
