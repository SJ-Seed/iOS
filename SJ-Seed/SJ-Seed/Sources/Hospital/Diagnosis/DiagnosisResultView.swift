//
//  DiagnosisResultView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/27/25.
//

import SwiftUI

struct DiagnosisResultView: View {
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
        ZStack {
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                BrownSpeechBubbleComponent(textString: "저 건강해요!")
                CloudPlantComponent(bg: Image(.clearCircle), icon: selectedProfile.icon, size: 230)
                PlantInfoButton(name: selectedProfile.name, action: {let _ = print("디테일뷰로이동")})
                CharacterSpeechComponent(
                    characterImage: .doctor1,
                    textString: "어머나,\n이렇게 튼튼하다니!"
                )
                .padding(.top, 10)
            }
            .padding(.top, 100)
        }
    }
}

#Preview {
    DiagnosisResultView()
}
