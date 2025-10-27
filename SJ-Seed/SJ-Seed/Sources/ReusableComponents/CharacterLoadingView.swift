//
//  CharacterLoadingView.swift
//  SJ-Seed
//
//  Created by 김나영 on 10/27/25.
//

import SwiftUI

struct CharacterLoadingView: View {
    var characterImage: ImageResource   // 하단 캐릭터 이미지
    var loadingText: String              // 말풍선 텍스트
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text(loadingText)
                    .font(.GodoMaum.regular.font(size: 38))
                    .foregroundColor(.brown1)
                
                Image(characterImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 330)
                    .padding(.top, 100)
                    .padding(.bottom, 60)
            }
        }
    }
}

#Preview {
    CharacterLoadingView(characterImage: .doctor2, loadingText: "뚝딱씨가 진료하는 중이에요 . . .")
}
