//
//  DiseaseExplainView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct DiseaseExplainView: View {
    let allProfiles: [PlantProfile] = [
            PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"),
            PlantProfile(id: UUID(), name: "상추", iconName: "lettuce"),
            PlantProfile(id: UUID(), name: "바질", iconName: "basil")
        ]
    
    @State private var selectedProfile: PlantProfile
    
    init() {
        _selectedProfile = State(initialValue: allProfiles[0])
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
            
            ScrollView {
                VStack {
                    Spacer().padding(.top, 80)
                    BrownSpeechBubbleComponent(textString: "병에 걸렸어요 . . .")
                    CloudPlantComponent(bg: Image(.cloudCircle), icon: selectedProfile.icon, size: 170)
                    PlantInfoButton(name: selectedProfile.name)
                    
                    DiseaseDetailCard(
                        diseaseName: "점무늬병",
                        symptom: "잎에 회갈색, 암갈색의 작은 반점이 생겨요. 심하게 감염되면 잎은 황색으로 변하면서 마르고 금방 시들어요.",
                        cause: "병원균은 씨앗이나 병든 부위에서 곰팡이 형태로 겨울을 보낸 후, 포자를 만들어서 공기로 전염돼요. 따뜻하고 습한 환경에서 많이 발생하고, 감염된 후 5일 이내에 증상이 나타나요.",
                        treatment: "씨앗을 선별하고, 소독한 후 심어야 해요. 병든 잎은 빨리 제거해야 하고, 온실에서는 내부가 너무 습하지 않도록 환기를 자주 시켜야 해요."
                    )
                    
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
                        }
                    }
                }
            }
            .ignoresSafeArea()
            
        }
    }
}

#Preview {
    DiseaseExplainView()
}
