//
//  SignUpView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import SwiftUI

enum SignUpStep {
    case welcome      // "어서 와~ 나는 쑥자씨라고 해..."
    case nameInput    // "너는 이름이 뭐니?" (이름 입력)
    case titleSelect  // "00로구나! 내가 어떻게 부르면 될까?" (호칭 선택)
    case info         // "자, 그럼 이제 나와 함께... 열쇠를 제작해보자!"
    case account      // "이제 열쇠를 만들어보렴" (아이디/비번 입력)
    case complete     // "열쇠가 완성된 모양이로구나... 입장하기"
}

struct SignUpView: View {
    @Environment(\.diContainer) private var di
    @StateObject private var viewModel = SignUpViewModel()
    
    @State private var step: SignUpStep = .welcome
    
    // 입력값 상태
//    @State private var name: String = ""
//    @State private var selectedTitle: String = "" // 양, 군, 씨
//    @State private var loginId: String = ""
//    @State private var password: String = ""
//    @State private var passwordCheck: String = ""
    
    var body: some View {
        ZStack {
            // 1. 배경 (고정)
            Image("loginBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // 2. 캐릭터 (고정, 단계별 표정 변화 가능)
                Image("grandma1") // 필요시 step에 따라 이미지 변경 가능
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
            }
            
            // 3. 말풍선 (단계별 전환)
            VStack {
                // 말풍선 컴포넌트
                SignUpBubbleView(
                    step: step,
                    name: $viewModel.name,
                    selectedTitle: $viewModel.selectedTitle,
                    loginId: $viewModel.loginId,
                    password: $viewModel.password,
                    passwordCheck: $viewModel.passwordCheck,
                    isLoading: viewModel.isLoading,     // 로딩 상태 전달
                    errorMessage: viewModel.errorMessage, // 에러 메시지 전달
                    onNext: handleNext
                )
                .padding(.horizontal, 30)
                
                Spacer().frame(height: 350) // 말풍선 위치 조정을 위한 여백
            }
        }
        // 화면 터치 시 키보드 내리기
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    // 다음 단계로 이동 로직
    private func handleNext() {
        withAnimation {
            switch step {
            case .welcome:
                step = .nameInput
            case .nameInput:
                if !viewModel.name.isEmpty { step = .titleSelect }
            case .titleSelect:
                if !viewModel.selectedTitle.isEmpty { step = .info }
            case .info:
                step = .account
            case .account:
                viewModel.register {
                    // 성공 시 실행될 클로저
                    withAnimation {
                        step = .complete
                    }
                }
            case .complete:
                // 로그인 화면으로 이동
                di.router.push(.loginInput)
            }
        }
    }
}

#Preview {
    SignUpView()
}
