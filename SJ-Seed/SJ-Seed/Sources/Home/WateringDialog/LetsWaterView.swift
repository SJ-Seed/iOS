//
//  LetsWaterView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/2/25.
//

import SwiftUI

struct LetsWaterView: View {
    var body: some View {
        ZStack {
            CharacterComponent(characterImage: "grandma3")
            Image(.ivoryBubble)
                .padding(.bottom, 250)
            VStack {
                Text("종이컵 반컵 정도\n물을 주자!")
                    .multilineTextAlignment(.center)
                Image(.waterCup)
                Button(action: { print("물을 줬어요") }) {
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

#Preview {
    LetsWaterView()
}
