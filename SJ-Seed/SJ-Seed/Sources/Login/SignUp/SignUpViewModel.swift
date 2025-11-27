//
//  SignUpViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//


import Foundation
import Combine

@MainActor
final class SignUpViewModel: ObservableObject {
    
    // 입력 데이터 (View와 바인딩)
    @Published var name: String = ""
    @Published var selectedTitle: String = "" // 양, 군, 씨
    @Published var loginId: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""
    
    // 상태 관리
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let authService = AuthService.shared
    
    // 회원가입 API 호출
    // completion: 성공 시 다음 단계(.complete)로 넘어가기 위한 클로저
    func register(completion: @escaping () -> Void) {
        // 1. 유효성 검사 (간단 예시)
        guard !name.isEmpty, !loginId.isEmpty, !password.isEmpty else {
            self.errorMessage = "모든 정보를 입력해주세요."
            return
        }
        
        guard password == passwordCheck else {
            self.errorMessage = "비밀번호가 일치하지 않습니다."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // 2. 이름 + 호칭 합치기 (예: "김나영" + "양" -> "김나영양")
        // (서버 스펙에 따라 name 필드에 합쳐서 보낼지, 따로 보낼지 결정. 여기서는 합쳐서 보낸다고 가정)
        // 만약 서버가 'nickname'을 따로 받는다면 수정 필요. 일단 name에 합칩니다.
        let fullName = name + selectedTitle
        
        // 3. 요청 모델 생성
        // (year, phoneNumber는 입력받는 뷰가 없으므로 임시값 또는 추가 입력 필요)
        // 여기서는 임시값(2025, "010-0000-0000")을 넣습니다. 필요하면 입력 단계 추가
        let request = SignUpRequest(
            name: fullName,
            year: 2025, // 임시 값
            loginId: loginId,
            password: password,
            phoneNumber: "" // 임시 값
        )
        
        // 4. 서비스 호출
        authService.signUp(request: request) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let data):
                print("✅ 회원가입 성공: \(data.name)")
                completion() // 성공 시 호출
                
            case .failure(let error):
                print("❌ 회원가입 실패:", error)
                self.errorMessage = "회원가입에 실패했습니다.\n다시 시도해주세요."
            }
        }
    }
}
