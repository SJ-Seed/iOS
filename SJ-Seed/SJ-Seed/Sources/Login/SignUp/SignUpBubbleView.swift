//
//  SignUpBubbleView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import SwiftUI

struct SignUpBubbleView: View {
    let step: SignUpStep
    
    @Binding var name: String
    @Binding var selectedTitle: String
    @Binding var loginId: String
    @Binding var password: String
    @Binding var passwordCheck: String
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    var onNext: () -> Void
    
    var body: some View {
        ZStack {
            // 배경 말풍선 이미지 (크기에 따라 늘어나게 설정 필요)
            // 여기서는 RoundedRectangle로 대체 (이미지 사용 시 resizable/renderingMode 확인)
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.ivory1)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                // 높이는 내용물에 따라 자동 조절되게 하거나, 고정 높이 사용
                // .frame(height: 300) 
            
            VStack(spacing: 20) {
                
                switch step {
                // 1. 환영 인사
                case .welcome:
                    Text("어서 와~ 나는 쑥자씨라고 해.\n숲속에서 풀과 꽃들을 돌보고 있단다.\n식물 키우는 비밀? 내가 다 알고 있지!")
                        .multilineTextAlignment(.center)
                        .font(Font.OwnglyphMeetme.regular.font(size: 20))
                        .lineSpacing(5)
                    
                    BrownButton(text: "다음", action: onNext)
                        
                // 2. 이름 입력
                case .nameInput:
                    Text("너는 이름이 뭐니?")
                        .font(Font.OwnglyphMeetme.regular.font(size: 22))
                    
                    CustomTextField(placeholder: "이름을 입력하세요", text: $name)
                    
                    BrownButton(text: "확인", action: onNext)
                        .disabled(name.isEmpty)
                    
                // 3. 호칭 선택
                case .titleSelect:
                    Text("\(name)로구나!\n내가 어떻게 부르면 될까?")
                        .multilineTextAlignment(.center)
                        .font(Font.OwnglyphMeetme.regular.font(size: 22))
                    
                    VStack(spacing: 10) {
                        TitleSelectionButton(title: "양", name: name, selectedTitle: $selectedTitle, action: onNext)
                        TitleSelectionButton(title: "군", name: name, selectedTitle: $selectedTitle, action: onNext)
                        TitleSelectionButton(title: "씨", name: name, selectedTitle: $selectedTitle, action: onNext)
                        // '그 이름이 아니에요'는 뒤로가기 로직 필요 (생략)
                    }
                    
                // 4. 열쇠(계정) 안내
                case .info:
                    Text("자, 그럼 이제 나와 함께\n쑥자숲 입장 열쇠를 제작해보자!\n이 열쇠는 잃어버리면 안된단다\n메모장에 담아두는걸 추천해~")
                        .multilineTextAlignment(.center)
                        .font(Font.OwnglyphMeetme.regular.font(size: 20))
                        .lineSpacing(5)
                    
                    BrownButton(text: "다음", action: onNext)
                    
                // 5. 계정 생성 (아이디/비번)
                case .account:
                    Text("이제 열쇠를 만들어보렴")
                        .font(Font.OwnglyphMeetme.regular.font(size: 22))
                    
                    VStack(spacing: 12) {
                        CustomTextField(placeholder: "아이디", text: $loginId)
                        CustomTextField(placeholder: "비밀번호", text: $password, isSecure: true)
                        CustomTextField(placeholder: "비밀번호 확인", text: $passwordCheck, isSecure: true)
                    }
                    
                    // 2. 에러 메시지 표시
                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    
                    // 3. 로딩 중일 때 버튼 변경
                    if isLoading {
                        ProgressView()
                            .tint(.brown1)
                    } else {
                        BrownButton(text: "열쇠 완성하기", iconName: "keyIcon", action: onNext)
                            .disabled(loginId.isEmpty || password.isEmpty || password != passwordCheck)
                    }
                    
                // 6. 완료
                case .complete:
                    Text("열쇠가 완성된 모양이로구나.\n열쇠를 잃어버릴까봐 걱정된다면\n마이페이지에 전화번호를 등록해두렴\n자, 이제 나와 쑥자 숲으로 들어가보자")
                        .multilineTextAlignment(.center)
                        .font(Font.OwnglyphMeetme.regular.font(size: 20))
                        .lineSpacing(5)
                    
                    BrownButton(text: "입장하기", action: onNext)
                }
            }
            .padding(30) // 내부 여백
            .foregroundStyle(Color.brown1)
        }
        .fixedSize(horizontal: false, vertical: true) // 내용물 크기에 맞게 높이 조절
    }
}

// MARK: - 재사용 컴포넌트들

// 공통 갈색 버튼
struct BrownButton: View {
    let text: String
    var iconName: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let iconName = iconName {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                Text(text)
            }
            .font(Font.OwnglyphMeetme.regular.font(size: 20))
            .foregroundStyle(.white) // 글자색 (시안은 아이보리/흰색)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.brown1)
                    .shadow(radius: 2, y: 2)
            )
        }
    }
}

// 호칭 선택 버튼 (초록색/갈색)
struct TitleSelectionButton: View {
    let title: String
    let name: String
    @Binding var selectedTitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            selectedTitle = title
            action()
        }) {
            Text("\(name)\(title)")
                .font(Font.OwnglyphMeetme.regular.font(size: 20))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        // 선택 시 색상 변경 로직을 넣을 수도 있음 (현재는 갈색 통일 or 초록)
                        .fill(Color.brown1) 
                )
        }
    }
}

// 입력 필드
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(.leading, 16)
                    .allowsHitTesting(false)
            }
            
            if isSecure {
                SecureField("", text: $text)
                    .padding(16)
            } else {
                TextField("", text: $text)
                    .padding(16)
            }
        }
        .contentShape(Rectangle())
        .font(Font.OwnglyphMeetme.regular.font(size: 18))
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}
