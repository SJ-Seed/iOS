//
//  HospitalView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/8/25.
//

import SwiftUI

struct HospitalView: View {
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
            // 배경
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack(alignment: .top) {
                    CloudPlantComponent(bg: Image(.clearCircle), icon: selectedProfile.icon, size: 230)
                        .padding(.top, 50)
                    
                    PlantPicker(selected: $selectedProfile, plants: allProfiles)
                        .padding(.horizontal, 80)
                }
                
                Button(action: {}) {
                    Text("뚝딱! 진료받기")
                        .font(Font.OwnglyphMeetme.regular.font(size: 22))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding()
                        .background(.brown1)
                        .cornerRadius(20)
                }
                
                CharacterSpeechComponent(
                    characterImage: .doctor,
                    textString: "혹시 모르니\n진료 한 번 받아볼래?"
                )
                .padding(.top, 10)
            }
            .padding(.top, 100)
        }
    }
}

#Preview {
    HospitalView()
}
