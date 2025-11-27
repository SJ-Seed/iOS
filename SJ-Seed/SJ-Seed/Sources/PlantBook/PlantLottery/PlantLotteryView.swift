//
//  PlantLotteryView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantLotteryView: View {
    @Environment(\.diContainer) private var di
    
    @StateObject private var viewModel = PlantLotteryViewModel()
    @State private var showFirst = false
    
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ZStack {
                HStack {
                    Button(action: { di.router.pop() }) {
                        Image("chevronLeft")
                            .foregroundStyle(.ivory1)
                            .padding(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Spacer()
                    
                    HeaderButton(
                        icon: Image(.coin),
                        text: "\(viewModel.currentCoin)"
                    )
                    .padding(.trailing)
                }
                Text("뽑기")
                    .font(Font.OwnglyphMeetme.regular.font(size: 28))
                    .foregroundStyle(.ivory1)
            }
            .padding(.top, 40)
            
            VStack {
                Spacer()
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
                
                if !viewModel.isAnimating && !viewModel.showText {
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
                } else if viewModel.isAnimating { // 뽑는 중
                    Text("두근두근...")
                        .foregroundStyle(.brown1)
                        .font(Font.OwnglyphMeetme.regular.font(size: 28))
                } else if !viewModel.isAnimating && viewModel.showText { // 꽝 나옴
                    Text("꽝이에요 😢")
                        .foregroundStyle(.brown1)
                        .font(Font.OwnglyphMeetme.regular.font(size: 28))
                }
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .task {
            viewModel.fetchCurrentCoin()
        }
        .alert("코인이 부족해요", isPresented: $viewModel.showCoinAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("뽑기를 하려면 1000코인이 필요해요.\n현재 코인: \(viewModel.currentCoin)")
        }
        .onChange(of: viewModel.resultName) {
            if let name = viewModel.resultName {
                // 'name'을 이용해 'PlantAssets'에서 'speciesId'를 찾음
                if let speciesId = PlantAssets.findSpeciesId(by: name) {
                    
                    // 'speciesId'를 DetailView로 전달
                    di.router.push(.plantDetail(speciesId: speciesId))
                    
                } else {
                    print("❌ PlantLotteryView: '\(name)'에 해당하는 speciesId를 PlantAssets에서 찾을 수 없습니다.")
                }
            }
        }
    }
}

#Preview {
    PlantLotteryView()
}
