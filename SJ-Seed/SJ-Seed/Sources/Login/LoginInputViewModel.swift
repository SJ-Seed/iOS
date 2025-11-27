//
//  LoginInputViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import Foundation
import Combine

@MainActor
final class LoginInputViewModel: ObservableObject {
    
    // 입력 데이터 (View와 바인딩)
    @Published var loginId: String = ""
    @Published var password: String = ""
    
    // UI 상태
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let authService = AuthService.shared
    
    // 로그인 함수
    // completion: 로그인 성공 시 View에게 알리기 위한 클로저
    func login(completion: @escaping () -> Void) {
        // 1. 유효성 검사
        guard !loginId.isEmpty, !password.isEmpty else {
            self.errorMessage = "아이디와 비밀번호를 입력해주세요."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // 2. 요청 모델 생성
        let request = SignInRequest(loginId: loginId, password: password)
        
        // 3. 서비스 호출
        authService.signIn(request: request) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let data):
                print("✅ 로그인 성공: \(data.name)님 환영합니다.")
                // 성공 시 뷰로 콜백 전달 (화면 이동)
                completion()
                
            case .failure(let error):
                print("❌ 로그인 실패:", error)
                // 에러 메시지를 사용자에게 보여주기 위해 설정
                self.errorMessage = "로그인에 실패했습니다.\n아이디와 비밀번호를 확인해주세요."
            }
        }
    }
}