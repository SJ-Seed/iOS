//
//  DiagnosisDocumentView.swift
//  SJ-Seed
//
//  Created by 김나영 on 9/30/25.
//

import SwiftUI

struct DiagnosisDocumentView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - 반복되는 구름 배경
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ForEach(0..<2) { _ in
                        Image(.cloudBG)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width)
                    }
                }
            }
            .ignoresSafeArea()
            
            // MARK: - ScrollView 콘텐츠
            ScrollView {
                VStack {
                    Spacer().padding(.top, 80)
                    ForEach(0..<6) { _ in
                        DocumentComponent()
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    
                    // 맨 밑 잔디 배경
                    ZStack {
                        Image(.grassBG)
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 40)
                        HStack {
                            Image(.doctor)
                                .padding(.top, 50)
                            IvorySpeechBubbleComponent(textString: "지금까지의\n진료기록이란다.")
                                .padding(.bottom, 150)
                        }
                    }
                }
//                .padding(.vertical, 20)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    DiagnosisDocumentView()
}
