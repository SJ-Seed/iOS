//
//  PlantListView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantListView: View {
    let plantList: [PlantInfo]
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
            ScrollView {
                VStack {
                    Spacer().padding(.top, 80)
                    ForEach(plantList) { record in
                        ListComponent(item: record)
                            .padding(.bottom, 8)
                    }
                    Button(action: { print("식물추가") }) {
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
//                .padding(.vertical, 20)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    let sampleProfiles = [
        PlantProfile(id: UUID(), name: "똥맛토", iconName: "tomato"),
        PlantProfile(id: UUID(), name: "토맛똥", iconName: "tomato"),
        PlantProfile(id: UUID(), name: "고추", iconName: "basil")
    ]
    
    let sampleRecords = [
        PlantInfo(plantProfile: sampleProfiles[0], dateText: "2025.09.01 ~", diagnosis: .normal),
        PlantInfo(plantProfile: sampleProfiles[1], dateText: "2025.09.07 ~", diagnosis: .disease("점무늬병")),
        PlantInfo(plantProfile: sampleProfiles[2], dateText: "2025.09.10 ~", diagnosis: .normal)
    ]
    PlantListView(plantList: sampleRecords)
}
