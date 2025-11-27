//
//  LoginMainView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//

import SwiftUI

struct LoginMainView: View {
    @Environment(\.diContainer) private var di
    var body: some View {
        ZStack {
            // 1. 배경 이미지
            Image("loginBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // 2. 캐릭터 이미지
            Image("student")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 40) // 좌우 여백
                .padding(.top, 200)     // 버튼과의 간격
            
//            VStack {
                Group {
                    Text("쑥자씨")
                        .font(Font.GodoMaum.regular.font(size: 128))
                        .padding(.bottom, 410)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    Text("쑥쑥 자라라 씨앗아")
                        .font(Font.GodoMaum.regular.font(size: 32))
                        .padding(.bottom, 270)
                }
                .foregroundStyle(Color.brown1)
                
                
                // 3. 하단 버튼 그룹
                VStack(spacing: 8) {
                    Spacer()
                    // 로그인 버튼 (쑥자 숲 입장하기)
                    LoginButton(
                        iconName: "keyIcon",
                        text: "쑥자 숲 입장하기",
                        action: { di.router.push(.loginInput) }
                    )
                    
                    // 회원가입 버튼 (쑥자씨는 처음이에요)
                    LoginButton(
                        iconName: "sproutIcon",
                        text: "쑥자씨는 처음이에요",
                        action: { di.router.push(.signUp) }
                    )
                }
                .padding(.horizontal, 60) // 버튼 좌우 여백
                .padding(.bottom, 80)     // 하단 여백
//            }
        }
    }
}

// MARK: - 공통 로그인/회원가입 버튼 컴포넌트
struct LoginButton: View {
    let iconName: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // 아이콘
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30) // 아이콘 크기 조절
                
                // 텍스트
                Text(text)
                    .font(Font.OwnglyphMeetme.regular.font(size: 24))
                    .foregroundStyle(.brown1) // 텍스트 색상 (갈색)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.ivory1) // 배경색 (아이보리)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.brown1, lineWidth: 3) // 테두리 (갈색)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LoginMainView()
}
