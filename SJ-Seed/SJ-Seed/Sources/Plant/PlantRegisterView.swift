//
//  PlantRegisterView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantRegisterView: View {
    @State private var step: RegisterStep = .enterCode
    @State private var plantCode: String = ""
    @State private var plantName: String = ""
    @State private var userName: String = "쑥쑥"
    @State private var foundPlant: String = "토마토"
    
    var body: some View {
        ZStack {
            CharacterComponent(characterImage: "grandma3")
            Image(.ivoryBubble)
                .padding(.bottom, 250)
            PlantRegisterBubbleText(
                step: step,
                userName: userName,
                plantCode: $plantCode,
                plantName: $plantName,
                foundPlant: foundPlant,
                onNext: handleNext,
                onPrevious: handlePrevious
            )
            .multilineTextAlignment(.center)
            .padding(.bottom, 270)
            .font(Font.OwnglyphMeetme.regular.font(size: 22))
            .foregroundStyle(.brown1)
        }
    }
    // 다음 단계로 이동
    func handleNext() {
        switch step {
        case .enterCode:
            step = .confirmPlant
        case .confirmPlant:
            step = .enterName
        case .enterName:
            step = .complete
        case .complete:
            break
        }
    }
    
    // 이전 단계로 이동
    func handlePrevious() {
            switch step {
            case .confirmPlant:
                step = .enterCode
            default:
                break
            }
        }
}

enum RegisterStep {
    case enterCode
    case confirmPlant
    case enterName
    case complete
}

#Preview {
    PlantRegisterView()
}
