//
//  LetsWaterView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/2/25.
//

import SwiftUI

struct LetsWaterView: View {
    @Environment(\.diContainer) private var di
    
    // 외부에서 주입받거나 init에서 생성
    @StateObject private var viewModel: WateringViewModel
    
    init(plantId: Int) {
        _viewModel = StateObject(wrappedValue: WateringViewModel(plantId: plantId))
    }
    
    var body: some View {
        // 상태에 따른 화면 전환
        switch viewModel.currentStep {
        case .instruction:
            instructionView // 기존 LetsWaterView 내용
            
        case .checking:
            CheckWateringView() // 로딩 뷰
            
        case .complete:
            CompleteWateringView(
                isSuccess: true,
                onConfirm: {
                    di.router.pop()
            })
        case .failure:
            CompleteWateringView(
                isSuccess: false,
                onConfirm: {
                    di.router.pop()
            })
        }
    }
    // MARK: - 1. 안내 화면 (기존 LetsWaterView 내용)
    var instructionView: some View {
        ZStack {
            CharacterComponent(characterImage: "grandma3")
            Image(.ivoryBubble)
                .padding(.bottom, 250)
            VStack {
                Text("종이컵 반컵 정도\n물을 주자!")
                    .multilineTextAlignment(.center)
                Image(.waterCup) // 이미지 에셋 확인 필요
                
                Button(action: {
                    // 버튼 누르면 검사 시작
                    viewModel.startWateringCheck()
                }) {
                    Text("물을 줬어요")
                        .font(Font.OwnglyphMeetme.regular.font(size: 18))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color.brown1)
                        .cornerRadius(12)
                }
            }
            .padding(.bottom, 270)
            .font(Font.OwnglyphMeetme.regular.font(size: 22))
            .foregroundStyle(.brown1)
        }
    }
}

//#Preview {
//    LetsWaterView()
//}
