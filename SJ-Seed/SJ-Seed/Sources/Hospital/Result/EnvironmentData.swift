//
//  EnvironmentData.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/29/25.
//


import SwiftUI
import Charts // iOS 16+ 필수

// 그래프 데이터 모델
struct EnvironmentData: Identifiable {
    let id = UUID()
    let date: String // "11/20" 등
    let value: Double
    let type: String // "온도" or "습도"
}

struct EnvironmentGraphView: View {
    let tempData: [EnvironmentData] = [
        .init(date: "D-6", value: 22, type: "온도"),
        .init(date: "D-5", value: 21, type: "온도"),
        .init(date: "D-4", value: 24, type: "온도"),
        .init(date: "D-3", value: 23, type: "온도"),
        .init(date: "D-2", value: 20, type: "온도"),
        .init(date: "D-1", value: 19, type: "온도"),
        .init(date: "오늘", value: 22, type: "온도")
    ]
    
    let humidityData: [EnvironmentData] = [
        .init(date: "D-6", value: 60, type: "습도"),
        .init(date: "D-5", value: 65, type: "습도"),
        .init(date: "D-4", value: 55, type: "습도"),
        .init(date: "D-3", value: 70, type: "습도"),
        .init(date: "D-2", value: 80, type: "습도"),
        .init(date: "D-1", value: 85, type: "습도"),
        .init(date: "오늘", value: 75, type: "습도")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("최근 7일간 온습도 변화")
                .font(Font.OwnglyphMeetme.regular.font(size: 24))
                .foregroundStyle(Color.brown1)
                .padding(.horizontal)
            
            // 1. 온도 그래프
            VStack(alignment: .leading) {
                HStack {
                    Image(.temperature)
                        .foregroundStyle(.brown1)
                    Text("온도 (℃)")
                        .font(Font.OwnglyphMeetme.regular.font(size: 18))
                        .foregroundStyle(.brown1)
//                        .padding(.leading)
                }
                
                Chart(tempData) { item in
                    LineMark(
                        x: .value("날짜", item.date),
                        y: .value("온도", item.value)
                    )
                    .foregroundStyle(Color.red.opacity(0.7))
                    .symbol(.circle) // 데이터 포인트 표시
                    .interpolationMethod(.catmullRom) // 부드러운 곡선
                    
                    AreaMark( // 아래쪽 색 채우기 (선택사항)
                        x: .value("날짜", item.date),
                        y: .value("온도", item.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.red.opacity(0.2), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 150)
                .chartYScale(domain: 0...40) // Y축 범위 고정
            }
            .padding(.horizontal)

            // 2. 습도 그래프
            VStack(alignment: .leading) {
                HStack {
                    Image(.humidity)
                        .foregroundStyle(.brown1)
                    Text("습도 (%)")
                        .font(Font.OwnglyphMeetme.regular.font(size: 18))
                        .foregroundStyle(.brown1)
//                        .padding(.leading)
                }
                
                Chart(humidityData) { item in
                    LineMark(
                        x: .value("날짜", item.date),
                        y: .value("습도", item.value)
                    )
                    .foregroundStyle(Color.blue.opacity(0.7))
                    .symbol(.circle)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("날짜", item.date),
                        y: .value("습도", item.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.2), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 150)
                .chartYScale(domain: 0...100)
            }
            .padding(.horizontal)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.ivory1)
                .padding(.horizontal)
        )
        .shadow(color: .brown.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    EnvironmentGraphView()
}
