//
//  MyPageViewModel.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/27/25.
//

import Foundation
import Combine

@MainActor
final class MyPageViewModel: ObservableObject {
    // UI 바인딩용 프로퍼티
    @Published var phoneNumber: String = ""
    @Published var isMusicOn: Bool {
        didSet {
            // 상태 변경 시 음악 제어 및 저장
            if isMusicOn {
                MusicManager.shared.playMusic()
            } else {
                MusicManager.shared.stopMusic()
            }
            UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
        }
    }
    @Published var showPhoneInputModal: Bool = false
    @Published var showPremiumAlert: Bool = false
    
    // API에서 받아올 데이터 (초기값 설정)
    @Published var userName = "로딩 중..."
    @Published var plantCount = 0
    @Published var pieceCount = 0
    @Published var badgeCount = 0 // API에 없으므로 0 또는 로컬 계산
    
    private let memberService = MemberService.shared
    // AuthManager에 저장된 내 ID 사용
    private var memberId: Int {
        return AuthManager.shared.currentMemberId
    }
    
    init() {
        self.phoneNumber = UserDefaults.standard.string(forKey: "userPhoneNumber") ?? ""
        
        // 3. 저장된 음악 설정 불러오기 (기본값 true)
        self.isMusicOn = UserDefaults.standard.object(forKey: "isMusicOn") as? Bool ?? true
        
        // 4. 초기 상태에 따라 음악 재생 (앱 켰을 때 자동 재생 원할 시)
        if self.isMusicOn {
            MusicManager.shared.playMusic()
        }
        
        fetchMemberDetail()
    }
    
    func savePhoneNumber(_ number: String) {
        self.phoneNumber = number
        UserDefaults.standard.set(number, forKey: "userPhoneNumber")
        self.showPhoneInputModal = false
    }
    
    // MARK: - 회원 정보 조회 API 호출
    func fetchMemberDetail() {
        // 로그인 전(0)이면 호출 안함
        guard memberId != 0 else {
             self.userName = "로그인 필요"
             return
        }
        
        memberService.getMemberDetail(memberId: memberId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                print("✅ 마이페이지 정보 로드 성공: \(data.name)")
                
                // UI 업데이트
                self.userName = data.name
                self.plantCount = data.plantNum
                self.pieceCount = data.pieceNum
                // self.badgeCount = data.badgeNum // (JSON에 없음)
                
            case .failure(let error):
                print("❌ 마이페이지 로드 실패:", error)
                self.userName = "알 수 없음"
            }
        }
    }
}
