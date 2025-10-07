//
//  CharacterSpeechComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/7/25.
//


import SwiftUI

struct CharacterSpeechComponent: View {
    var characterImage: ImageResource   // 하단 캐릭터 이미지
    var textString: String              // 말풍선 텍스트

    var body: some View {
        HStack(alignment: .bottom) {
            // 캐릭터 이미지
            Image(characterImage)
                .resizable()
                .scaledToFit()
                .frame(height: 230)
                .padding(.top, 50)

            // 아이보리 말풍선
            IvorySpeechBubbleComponent(textString: textString)
                .padding(.bottom, 140)
        }
    }
}

#Preview {
    CharacterSpeechComponent(
        characterImage: .doctor,
        textString: "지금까지의\n진료기록이란다."
    )
}
