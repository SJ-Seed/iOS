//
//  IvorySpeechBubbleComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/5/25.
//

import SwiftUI

struct IvorySpeechBubbleComponent: View {
    var textString: String
    var body: some View {
        ZStack {
            Image(.ivorySpeechBubble)
            Text(textString)
                .multilineTextAlignment(.center)
                .font(Font.OwnglyphMeetme.regular.font(size: 22))
                .foregroundStyle(.brown1)
                .offset(y: -7)
        }
    }
}

#Preview {
    IvorySpeechBubbleComponent(textString: "지금까지의\n진료 기록이란다.")
}
