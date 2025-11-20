//
//  AuthManager.swift
//  SJ-Seed
//
//  Created by 김나영 on 11/3/25.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private init() {}

    // 개발용 하드코딩 토큰
    private let devToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdHJpbmciLCJpYXQiOjE3NjM2MDM3OTYsImV4cCI6MTc2MzY5MDE5Nn0.wJ6_TQNO9owewmHGib485zS8Qfu47BZTyDM3WoVGvHQ"

    // 현재 토큰 (실제 로그인 시에는 여기 업데이트)
    var accessToken: String {
        // 로그인 기능 연결 후에는 UserDefaults 등에서 불러오게 변경 가능
        return UserDefaults.standard.string(forKey: "accessToken") ?? devToken
    }
}
