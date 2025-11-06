//
//  PlantLotteryView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantLotteryView: View {
    @StateObject private var viewModel = PlantLotteryViewModel()
    @State private var showFirst = false
//    @State private var isAnimating = false   // 애니메이션 시작 여부
//    @State private var showText = false      // "두근두근..." 텍스트 표시
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
                    guard viewModel.isAnimating else { return }
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showFirst.toggle()
                    }
                }
            
            if let name = viewModel.resultName {
                VStack {
                    Text("🌱 뽑힌 식물 🌱")
                        .font(Font.OwnglyphMeetme.regular.font(size: 26))
                        .foregroundColor(.brown1)
                        .padding(.bottom, 4)
                    
                    Text(name)
                        .font(Font.OwnglyphMeetme.regular.font(size: 36))
                        .foregroundColor(.green1)
                }
                .offset(y: 180)
                .transition(.opacity.combined(with: .scale))
            }
            
            if !viewModel.isAnimating && viewModel.resultName == nil {
                Button(action: {
                    withAnimation(.easeInOut) {
                        viewModel.drawPlant()
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
            } else if viewModel.showText {
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
