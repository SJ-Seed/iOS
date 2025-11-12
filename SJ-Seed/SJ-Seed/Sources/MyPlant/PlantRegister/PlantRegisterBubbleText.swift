//
//  PlantRegisterBubbleText.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantRegisterBubbleText: View {
    var step: RegisterStep
    var userName: String
    @Binding var plantCode: String
    @Binding var plantName: String
    
    var isLoading: Bool
    var errorMessage: String?
    var registeredPlantUserName: String
    var registeredPlantSpeciesName: String
    
    var onNext: () -> Void
    var onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            switch step {
            case .enterCode:
                Text("식물 코드를 입력해줘!")
                TextField("화분에 적힌 식물 코드", text: $plantCode)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 240)
                    .cornerRadius(20)
                    .padding(.bottom, 8)
                Button(action: onNext) {
                    Text("확인")
                        .foregroundStyle(.ivory1)
                        .frame(width: 240, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.brown1)
                        )
                }
                
            case .enterName:
                Text("식물에게 이름을 지어줘!")
                TextField("식물 이름", text: $plantName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 240)
                    .cornerRadius(20)
                    .padding(.bottom, 8)
                
                // 로딩 중이 아닐 때만 버튼 표시
                if !isLoading {
                    Button(action: onNext) {
                        Text("확인")
                            .foregroundStyle(.ivory1)
                            .frame(width: 240, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.brown1)
                            )
                    }
                }
                
                //  로딩 및 에러 메시지 표시
                if isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    Text(error)
                        .font(Font.OwnglyphMeetme.regular.font(size: 18))
                        .foregroundStyle(.red)
                        .padding(.top, 5)
                }
                
            case .complete:
                Text("\(registeredPlantUserName) (\(registeredPlantSpeciesName)) 을/를\n\(userName)의 식물로 등록했단다.\n잘 돌봐주도록 해!")
                    .padding(.bottom, 8)
                    .frame(width: 240)
                Button(action: onComplete) {
                    Text("확인")
                        .foregroundStyle(.ivory1)
                        .frame(width: 240, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.brown1)
                        )
                }
            }
        }
        .padding()
        .cornerRadius(20)
    }
}
