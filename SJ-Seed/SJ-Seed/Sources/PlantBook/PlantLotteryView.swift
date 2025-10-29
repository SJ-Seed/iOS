//
//  PlantLotteryView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantLotteryView: View {
    @State private var showFirst = false
    @State private var isAnimating = false   // 애니메이션 시작 여부
    @State private var showText = false      // "두근두근..." 텍스트 표시
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Image(showFirst ? "gacha1" : "gacha2")
                .resizable()
                .scaledToFit()
                .frame(width: 350)
                .offset(y: -50)
                .onReceive(timer) { _ in
                    guard isAnimating else { return }
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showFirst.toggle()
                    }
                }
            
            if !isAnimating {
                Button(action: {
                    withAnimation(.easeInOut) {
                        isAnimating = true
                        showText = true
                    }
                    
                    // 3초 뒤 애니메이션 종료
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isAnimating = false
                            showText = false
                            // TODO: 다음 단계 (ex. 결과 뽑기 화면으로 전환)
                        }
                    }
                }) {
                    Text("1000코인 지불 후 뽑기")
                        .foregroundStyle(.ivory1)
                        .font(Font.OwnglyphMeetme.regular.font(size: 22))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.brown1)
                                .frame(width: 220, height: 50)
                        )
                }
                .offset(y: 150)
            } else if showText {
                Text("두근두근...")
                    .foregroundStyle(.brown1)
                    .font(Font.OwnglyphMeetme.regular.font(size: 28))
                    .offset(y: 150)
            }
        }
    }
}

#Preview {
    PlantLotteryView()
}
