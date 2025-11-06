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
    var foundPlant: String
    var onNext: () -> Void
    var onPrevious: () -> Void
    
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
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.brown1)
                                .frame(width: 240, height: 40)
                        )
                }
                
            case .confirmPlant:
                VStack {
                    Text("\(userName)이 등록하려는 식물이\n“\(foundPlant)” 맞니?")
                    Button(action: onNext) {
                        Text("맞아요")
                            .foregroundStyle(.ivory1)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.brown1)
                                    .frame(width: 190, height: 40)
                            )
                    }
                    .padding()
                    Button(action: onPrevious) {
                        Text("아니에요")
                            .foregroundStyle(.ivory1)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.brown1)
                                    .frame(width: 190, height: 40)
                            )
                    }
                }
                
            case .enterName:
                Text("식물에게 이름을 지어줘!")
                TextField("식물 이름", text: $plantName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 240)
                    .cornerRadius(20)
                    .padding(.bottom, 8)
                Button(action: onNext) {
                    Text("확인")
                        .foregroundStyle(.ivory1)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.brown1)
                                .frame(width: 240, height: 40)
                        )
                }
                
            case .complete:
                Text("해당 식물을\n\(userName)의 식물로 등록했단다.\n잘 돌봐주도록 해!")
            }
        }
        .padding()
        .cornerRadius(20)
    }
}
