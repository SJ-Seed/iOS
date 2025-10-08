//
//  HospitalView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/8/25.
//

import SwiftUI

struct HospitalView: View {
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text("토마토")
                    .font(Font.OwnglyphMeetme.regular.font(size: 28))
                    .foregroundStyle(.brown1)
                
                CloudPlantComponent(bg: Image(.clearCircle), icon: Image(.sprout), size: 250)
                    .padding(.bottom)
                
                Button(action: {}) {
                    Text("뚝딱! 진료받기")
                        .font(Font.OwnglyphMeetme.regular.font(size: 22))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding()
                        .background(.brown1)
                        .cornerRadius(20)
                }
                
                CharacterSpeechComponent(characterImage: .doctor, textString: "혹시 모르니\n진료 한 번 받아볼래?")
            }
            .padding(.top, 80)
        }
//        .background(
//            Image(.background)
//                .resizable()
//                .ignoresSafeArea()
//                .scaledToFill()
//        )
    }
}

#Preview {
    HospitalView()
}
