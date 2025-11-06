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
                        text: "1200"
                        // TODO: - 코인 api 연결해야함
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
                
                if !viewModel.isAnimating {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.drawPlant()
                            // TODO: -1000코인 지불 api 연결 필요
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
                } else if viewModel.showText {
                    Text("두근두근...")
                        .foregroundStyle(.brown1)
                        .font(Font.OwnglyphMeetme.regular.font(size: 28))
                }
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .bottom)
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
