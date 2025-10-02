//
//  CharacterComponent.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/2/25.
//

import SwiftUI

struct CharacterComponent: View {
    var characterImage: String = "grandma1"
    var body: some View {
        VStack {
            Spacer()
            Image(characterImage)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 90)
        }
        .background(
            Image(.background)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
        )
    }
}
#Preview {
    CharacterComponent(characterImage: "grandma2")
}
