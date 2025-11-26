//
//  BrownSpeechBubbleComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/25/25.
//

import SwiftUI

struct BrownSpeechBubbleComponent: View {
    var textString: String
    var body: some View {
        ZStack {
            Image(.brownSpeechBubble)
            Text(textString)
                .font(Font.OwnglyphMeetme.regular.font(size: 22))
                .multilineTextAlignment(.center)
                .foregroundStyle(.ivory1)
                .padding(.horizontal, 75)
                .offset(y: -13)
        }
    }
}

#Preview {
    BrownSpeechBubbleComponent(textString: "사진이 잘 보이지 않아요")
}
