//
//  PlantLotteryView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/28/25.
//

import SwiftUI

struct PlantLotteryView: View {
    @State private var showFirst = true
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
//            VStack {
                Image(showFirst ? "gacha1" : "gacha2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .onReceive(timer) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showFirst.toggle()
                        }
                    }
                    .offset(x: 0, y: -50)
                
                Button(action: { }) {
                    Text("1000코인 지불 후 뽑기")
                        .foregroundStyle(.ivory1)
                        .font(Font.OwnglyphMeetme.regular.font(size: 22))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.brown1)
                                .frame(width: 220, height: 50)
                        )
                }
                .offset(x: 0, y: 150)
//            }
        }
    }
}

#Preview {
    PlantLotteryView()
}
