//
//  HospitalLoadingView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/26/25.
//

import SwiftUI

struct HospitalLoadingView: View {
    @State private var dotCount = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            CharacterComponent(characterImage: "doctor2")
            Text("뚝딱 씨가 진료하는 중이에요\(String(repeating: " .", count: dotCount))")
                .font(Font.GodoMaum.regular.font(size: 37))
                .foregroundStyle(.brown1)
                .offset(x: 0, y: -100)
                .multilineTextAlignment(.center)
        }
        .onReceive(timer) { _ in
            if dotCount == 3 {
                dotCount = 0 // 3개면 다시 0개로
            } else {
                dotCount += 1 // 아니면 1개 추가
            }
        }
    }
}

#Preview {
    HospitalLoadingView()
}
