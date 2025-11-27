//
//  LoginInputView.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import SwiftUI

struct LoginInputView: View {
    @Environment(\.diContainer) private var di
    
    @StateObject private var viewModel = LoginInputViewModel()
    
    // 입력값 상태 관리
//    @State private var idInput: String = ""
//    @State private var passwordInput: String = ""
    
    var body: some View {
        ZStack {
            // 1. 배경 (LoginMainView와 동일)
            Image("loginBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // 하단 캐릭터 (배경 요소)
                HStack {
                    Spacer()
                    Image("student")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
//                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    Image("grandma2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130)
//                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                        .padding(.trailing, 30)
                }
            }
            
            // 2. 중앙 로그인 카드
            ZStack {
                // 카드 배경
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.ivory1)
                    .frame(width: 320, height: 400) // 크기는 적절히 조절 가능
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                
                VStack(spacing: 25) {
                    // 상단 헤더 (뒤로가기 + 타이틀)
                    ZStack {
                        HStack {
                            Button(action: { di.router.pop() }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.brown1)
                            }
                            Spacer()
                        }
                        
                        Text("쑥자씨")
                            .font(Font.OwnglyphMeetme.regular.font(size: 40))
                            .foregroundStyle(.brown1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                    LoginTextField(placeholder: "아이디", text: $viewModel.loginId)
                    LoginTextField(placeholder: "비밀번호", text: $viewModel.password, isSecure: true)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        // 로딩 중이면 중복 클릭 방지
                        guard !viewModel.isLoading else { return }
                        
                        // 키보드 내리기
                        hideKeyboard()
                        
                        // 로그인 요청
                        viewModel.login {
                            // ✅ 로그인 성공 시 실행되는 클로저
                            // 홈 화면으로 이동 (Navigation Stack을 초기화하고 이동하는 것이 좋음)
                            di.router.reset() // 기존 스택 비우기 (로그인 화면으로 못 돌아오게)
                            di.router.push(.home) // 홈으로 이동
                        }
                        
                    }) {
                        HStack(spacing: 10) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.ivory1)
                            } else {
                                Image("keyIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                Text("쑥자 숲 입장하기")
                                    .font(Font.OwnglyphMeetme.regular.font(size: 24))
                            }
                        }
                        .foregroundStyle(.ivory1)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.brown1)
                        )
                    }
                    .padding(.top, 10)
                    .disabled(viewModel.isLoading)
                }
                .frame(width: 280) // 내부 컨텐츠 너비 제한
            }
            // 키보드가 올라왔을 때 뷰가 가려지는 것을 방지하기 위한 오프셋 조정 (선택 사항)
            .offset(y: -50)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
        }
        .onTapGesture {
            hideKeyboard()
        }
        // (선택사항) 에러 발생 시 알림창으로 보여주려면 .alert 사용 가능
        .alert("로그인 실패", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("확인", role: .cancel) { }
        } message: {
            if let message = viewModel.errorMessage {
                Text(message)
            }
        }
    }
    
    // 키보드 내리는 헬퍼 함수
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - 커스텀 텍스트 필드 컴포넌트
struct LoginTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(Font.OwnglyphMeetme.regular.font(size: 20))
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .padding(.leading, 20)
            }
            
            if isSecure {
                SecureField("", text: $text)
                    .padding(.horizontal, 20)
                    .frame(height: 60)
            } else {
                TextField("", text: $text)
                    .padding(.horizontal, 20)
                    .frame(height: 60)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
        )
        .font(Font.OwnglyphMeetme.regular.font(size: 20))
        .foregroundStyle(.brown1)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
    }
}

#Preview {
    LoginInputView()
}
