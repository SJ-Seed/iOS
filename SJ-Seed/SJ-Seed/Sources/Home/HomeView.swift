//
//  HomeView.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/15/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HeaderBarGroup(
                coin: 1200,
                onTapMy: { },
                onTapCoin: { }
            )
            PlantStateComponent(
                    viewModel: PlantStateViewModel(
                        plant: PlantInfo(
                            name: "토마토",
                            iconName: "sprout",
                            vitals: PlantVitals(temperature: 33, humidity: 65, soil: .dry)
                        ),
                        statusMessage: "덥고 목말라요😣",
                        shouldWater: true
                    )
                )
                .padding(.horizontal, 25)
                .padding(.bottom)
            AttendanceComponent(
                    attendance: WeeklyAttendance(
                        days: Weekday.allCases.map { wd in
                            // 예시: 오늘 화요일만 체크
                            AttendanceDay(weekday: wd, isChecked: wd == .tue)
                        },
                        todayRewardCoin: 50
                    )
                )
                .padding(.horizontal, 25)
            HStack {
                MainButtonComponent(buttonImage: Image(.student), buttonText: "도감")
                MainButtonComponent(buttonImage: Image(.grandma2), buttonText: "식물")
                MainButtonComponent(buttonImage: Image(.doctor), buttonText: "병원")
            }
            .padding(.top, 30)
        }
        .background(
            Image(.background)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
        )
    }
}

struct HeaderBarGroup: View {
    var coin: Int
    var onTapMy: () -> Void = {}
    var onTapCoin: () -> Void = {}

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
                text: "\(coin)",
                onTap: onTapCoin
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
