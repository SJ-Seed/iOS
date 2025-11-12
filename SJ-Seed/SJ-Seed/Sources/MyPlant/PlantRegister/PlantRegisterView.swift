//
//  PlantRegisterView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantRegisterView: View {
    @Environment(\.diContainer) private var di
    
    @State private var step: RegisterStep = .enterCode
    @State private var plantCode: String = ""
    @State private var plantName: String = ""
    @State private var userName: String = "쑥쑥"
    @State private var foundPlant: String = "토마토"
    
    @StateObject private var viewModel = PlantRegisterViewModel()
    
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
                isLoading: viewModel.isLoading,
                errorMessage: viewModel.errorMessage,
                registeredPlantUserName: viewModel.registeredPlantUserName,
                registeredPlantSpeciesName: viewModel.registeredPlantSpeciesName,
                onNext: handleNext,
                onComplete: { di.router.pop() }
            )
            .multilineTextAlignment(.center)
            .padding(.bottom, 270)
            .font(Font.OwnglyphMeetme.regular.font(size: 22))
            .foregroundStyle(.brown1)
            
            Button(action: { di.router.pop() }) {
                Image("chevronLeft")
                    .foregroundStyle(.ivory1)
                    .padding(.trailing, 280)
            }
            .padding(.bottom, 690)
        }
    }
    // 다음 단계로 이동
    func handleNext() {
        switch step {
        case .enterCode:
            guard !plantCode.isEmpty else { return } // TODO: 코드 비어있을 때 알림
            step = .enterName
//        case .confirmPlant:
//            step = .enterName
        case .enterName:
            if viewModel.errorMessage != nil {
                step = .enterCode
                
                plantCode = ""
                plantName = ""
                viewModel.errorMessage = nil
                
            } else {
                guard !plantName.isEmpty else { return } // 이름 비어있을 때 알림 (TODO)
                viewModel.registerPlant(name: plantName, code: plantCode) { isSuccess in
                    if isSuccess {
                        // API 호출 성공
                        step = .complete
                    } else {
                        // API 호출 실패
                        // ViewModel의 'errorMessage'
                    }
                }
            }
        case .complete:
            break
        }
    }
}

enum RegisterStep {
    case enterCode
    case enterName
    case complete
}

#Preview {
    PlantRegisterView()
}
