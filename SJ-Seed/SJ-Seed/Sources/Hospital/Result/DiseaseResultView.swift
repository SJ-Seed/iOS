//
//  DiseaseExplainView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct DiseaseResultView: View {
    @Environment(\.diContainer) private var di
    
    let plant: PlantProfile
    let result: TreatmentResult
    
//    let allProfiles: [PlantProfile] = [
//            PlantProfile(id: UUID(), name: "토마토", iconName: "tomato"),
//            PlantProfile(id: UUID(), name: "상추", iconName: "lettuce"),
//            PlantProfile(id: UUID(), name: "바질", iconName: "basil")
//        ]
    
//    @State private var selectedProfile: PlantProfile
    
//    init() {
//        _selectedProfile = State(initialValue: allProfiles[0])
//    }
    
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
                    headerView
                    Spacer().padding(.top, 80)
                    BrownSpeechBubbleComponent(textString: "병에 걸렸어요 . . .")
                    CloudPlantComponent(bg: Image(.cloudCircle), icon: plant.icon, size: 170)
//                    PlantInfoButton(name: selectedProfile.name, action: <#() -> Void#>)
                    
                    DiseaseDetailCard(
                        diseaseName: result.state ?? "진단명 없음",
                        symptom: result.explain ?? "증상 정보가 없습니다.",
                        cause: result.cause ?? "원인 정보가 없습니다.",
                        treatment: result.cure ?? "치료법 정보가 없습니다."
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
            
            // 인덱스 중앙
            Text("검사 결과")
                .font(Font.OwnglyphMeetme.regular.font(size: 28))
                .foregroundStyle(.brown1)
        }
    }
}

#Preview {
//    DiseaseResultView()
}
