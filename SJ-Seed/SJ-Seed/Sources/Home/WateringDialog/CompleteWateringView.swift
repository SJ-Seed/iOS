//
//  CompleteWateringView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/2/25.
//

import SwiftUI

struct CompleteWateringView: View {
    var isSuccess: Bool = false
    var onConfirm: () -> Void = {}
    
    var body: some View {
        ZStack {
            CharacterComponent(characterImage: "grandma3")
            Image(.ivoryBubble)
                .padding(.bottom, 250)
            Text(isSuccess ?
                 "물을 잘 줬구나!\n\n앞으로도 잘 돌봐주렴~\n선물로 100코인을 줄게"
                 : "물주기가 확인 되지 않았어.😢\n\n물을 주지 않았다면 다시 물을 주거나,\n물주기 버튼을 다시 눌러볼래?"
            )
                .multilineTextAlignment(.center)
                .padding(.bottom, 340)
                .font(Font.OwnglyphMeetme.regular.font(size: 22))
                .foregroundStyle(.brown1)
            Button(action: { onConfirm() }) {
                Text("확인")
                    .font(Font.OwnglyphMeetme.regular.font(size: 18))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .background(Color.brown1)
                    .cornerRadius(12)
            }
            .padding(.bottom, 140)
        }
    }
}

#Preview {
    CompleteWateringView()
}
