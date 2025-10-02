//
//  CompleteWateringView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/2/25.
//

import SwiftUI

struct CompleteWateringView: View {
    var body: some View {
        ZStack {
            CharacterComponent(characterImage: "grandma3")
            Image(.ivoryBubble)
                .padding(.bottom, 250)
            Text("물을 잘 줬구나!\n\n“또마똥”이(가) 매우 기뻐하고 있어\n앞으로도 잘 돌봐주렴~\n\n선물로 100코인을 줄게")
                .multilineTextAlignment(.center)
                .padding(.bottom, 270)
                .font(Font.OwnglyphMeetme.regular.font(size: 22))
                .foregroundStyle(.brown1)
        }
    }
}

#Preview {
    CompleteWateringView()
}
