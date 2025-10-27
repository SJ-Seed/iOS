//
//  CheckWateringView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/2/25.
//

import SwiftUI

struct CheckWateringView: View {
    var body: some View {
        ZStack {
            CharacterComponent(characterImage: "grandma2")
            Text("물 주기 확인 중이에요 . . .")
                .font(Font.GodoMaum.regular.font(size: 32))
                .foregroundStyle(.brown1)
                .offset(x: 0, y: -100)
        }
    }
}

#Preview {
    CheckWateringView()
}
