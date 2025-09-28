//
//  SpeechBubbleComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/25/25.
//

import SwiftUI

struct SpeechBubbleComponent: View {
    var textString: String
    var body: some View {
        ZStack {
            Image(.speechBubble)
            Text(textString)
                .font(Font.OwnglyphMeetme.regular.font(size: 22))
                .foregroundStyle(.ivory1)
                .offset(y: -13)
        }
    }
}

#Preview {
    SpeechBubbleComponent(textString: "덥고 목말라요😣")
}
