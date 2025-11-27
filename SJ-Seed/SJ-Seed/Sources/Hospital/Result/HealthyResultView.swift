//
//  HealthyResultView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/27/25.
//

import SwiftUI

struct HealthyResultView: View {
    @Environment(\.diContainer) private var di
    
//    let allProfiles: [PlantProfile] = [
//            PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"),
//            PlantProfile(id: UUID(), name: "상추", iconName: "lettuce"),
//            PlantProfile(id: UUID(), name: "바질", iconName: "basil")
//        ]
    
//    @State private var selectedProfile: PlantProfile
    
    let plant: PlantProfile
    let result: TreatmentResult
    
//    init() {
//        _selectedProfile = State(initialValue: allProfiles[0])
//    }
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                headerView
                VStack {
                    BrownSpeechBubbleComponent(textString: result.message ?? "저 건강해요!")
                    CloudPlantComponent(bg: Image(.clearCircle), icon: plant.icon, size: 230)
//                    PlantInfoButton(name: plant.name, action: {di.router.push(.myPlantDetail(plantId: 1))})
                    Text(plant.name)
                        .font(Font.OwnglyphMeetme.regular.font(size: 24))
                        .foregroundStyle(Color.brown1)
                    CharacterSpeechComponent(
                        characterImage: .doctor1,
                        textString: "어머나,\n이렇게 튼튼하다니!"
                    )
                    .padding(.top, 10)
                }
//                .padding(.top, 100)
            }
        }
    }
    
    private var headerView: some View {
        ZStack {
            HStack {
                Button(action: { di.router.pop() }) {
                    Image("chevronLeft")
                        .foregroundStyle(.ivory1)
                        .padding(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                Spacer()
            }
            
            // 인덱스 중앙
            Text("검사 결과")
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
                .foregroundStyle(.ivory1)
        }
    }
}

#Preview {
    HealthyResultView(plant: PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"), result: TreatmentResult(photo: true, state: "", message: "", explain: "", cause: "", cure: ""))
}
